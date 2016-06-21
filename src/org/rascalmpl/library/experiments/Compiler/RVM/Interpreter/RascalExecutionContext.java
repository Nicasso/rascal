package org.rascalmpl.library.experiments.Compiler.RVM.Interpreter;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;

import org.rascalmpl.debug.IRascalMonitor;
import org.rascalmpl.interpreter.Configuration;
import org.rascalmpl.interpreter.ConsoleRascalMonitor;
import org.rascalmpl.interpreter.DefaultTestResultListener;
import org.rascalmpl.interpreter.Evaluator;
import org.rascalmpl.interpreter.ITestResultListener;
import org.rascalmpl.interpreter.load.IRascalSearchPathContributor;
import org.rascalmpl.interpreter.load.RascalSearchPath;
import org.rascalmpl.interpreter.load.StandardLibraryContributor;
import org.rascalmpl.interpreter.load.URIContributor;
import org.rascalmpl.interpreter.result.ICallableValue;
import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.observers.CallTraceObserver;
import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.observers.CoverageFrameObserver;
import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.observers.DebugFrameObserver;
import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.observers.IFrameObserver;
import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.observers.NullFrameObserver;
import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.observers.ProfileFrameObserver;
import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.observers.RVMTrackingObserver;
import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.traverse.DescendantDescriptor;
import org.rascalmpl.uri.URIUtil;
import org.rascalmpl.value.IConstructor;
import org.rascalmpl.value.IListWriter;
import org.rascalmpl.value.IMap;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.IString;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;
import org.rascalmpl.value.type.Type;
import org.rascalmpl.value.type.TypeFactory;
import org.rascalmpl.value.type.TypeStore;
import org.rascalmpl.values.uptr.RascalValueFactory;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import com.github.benmanes.caffeine.cache.stats.CacheStats;

/**
 * Provides all context information that is needed during the execution of a compiled Rascal program
 * and contains:
 * - I/O streams
 * - class loaders
 * - RascalSearchPath
 * - execution flags
 * - state variables need by RascalPrimitives
 *
 */
public class RascalExecutionContext implements IRascalMonitor {

	private IRascalMonitor monitor;
	private final PrintWriter stderr;
	private final Configuration config;
	private final List<ClassLoader> classLoaders;
	private final PrintWriter stdout;
	
	private final IValueFactory vf;
	private final TypeStore typeStore;
	private final boolean debug;
	private final boolean debugRVM;
	private final boolean testsuite;
	private final boolean profile;
	private final boolean trace;
	private final ITestResultListener testResultListener;
	private IFrameObserver frameObserver;
	private final IMap symbol_definitions;
	private RascalSearchPath rascalSearchPath;
	
	private String currentModuleName;
	private RVMCore rvm;
	private boolean coverage;
	private boolean jvm;
	private final IMap moduleTags;
	private Map<IValue, IValue> moduleVariables;
	
	private Cache<Type[], Boolean> subtypeCache;
	private final int subtypeCacheSize = 1000;
	
	private final int type2symbolCacheSize = 1000;
	private final int descendantDescriptorCacheSize = 1000;
	
	private Cache<String, Function> companionDefaultFunctionCache;
	private final int companionDefaultFunctionCacheSize = 100;
	
	private Cache<String, Function> companionFieldDefaultFunctionCache;
	private final int companionFieldDefaultFunctionCacheSize = 100;
	
//	private Cache<String,  Class<IGTD<IConstructor, ITree, ISourceLocation>>> parserCache;
//	private final int parserCacheSize = 30;
	
	Cache<String, IValue> parsedModuleCache;
	private final int parsedModuleCacheSize = 10;
	
	// State for RascalPrimitive
	
	private final ParsingTools parsingTools; 
	Stack<String> indentStack = new Stack<String>();
	private Cache<Type, IConstructor> type2symbolCache;
	
	StringBuilder templateBuilder = null;
	private final Stack<StringBuilder> templateBuilderStack = new Stack<StringBuilder>();
	private IListWriter test_results;
	
	private Cache<IString, DescendantDescriptor> descendantDescriptorCache;
	
	private static Cache<IValue, IValue> sharedConstantCache = Caffeine.newBuilder()
//			.weakKeys()
		    .weakValues()
//		    .recordStats()
			.maximumSize(10000)
			.build();
	
	private static Cache<Type, Type> sharedTypeConstantCache = Caffeine.newBuilder()
//			.weakKeys()
		    .weakValues()
//		    .recordStats()
			.maximumSize(10000)
			.build();
	
	public RascalExecutionContext(
			IValueFactory vf, 
			PrintWriter stdout, 
			PrintWriter stderr, 
			IMap moduleTags, 
			IMap symbol_definitions, 
			TypeStore typeStore,
			boolean debug, 
			boolean debugRVM, 
			boolean testsuite, 
			boolean profile, 
			boolean trace, 
			boolean coverage, 
			boolean jvm, 
			ITestResultListener testResultListener, 
			IFrameObserver frameObserver,
			RascalSearchPath rascalSearchPath
	){
		
		this.vf = vf;
		this.moduleTags = moduleTags;
		this.symbol_definitions = symbol_definitions;
		this.typeStore = typeStore == null ? RascalValueFactory.getStore() /*new TypeStore()*/ : typeStore;
		this.debug = debug;
		this.debugRVM = debugRVM;
		this.testsuite = testsuite;
	
		this.profile = profile;
		this.coverage = coverage;
		this.jvm = jvm;
		this.trace = trace;
		
		currentModuleName = "UNDEFINED";
		
		if(rascalSearchPath == null){
			this.rascalSearchPath = new RascalSearchPath();
			addRascalSearchPath(URIUtil.rootLocation("test-modules"));
            addRascalSearchPathContributor(StandardLibraryContributor.getInstance());
		} else {
			this.rascalSearchPath = rascalSearchPath;
		}
	
		monitor = new ConsoleRascalMonitor(); //ctx.getEvaluator().getMonitor();
		this.stdout = stdout;
		this.stderr = stderr;
		config = new Configuration();
		this.classLoaders = new ArrayList<ClassLoader>(Collections.singleton(Evaluator.class.getClassLoader()));
		this.testResultListener = (testResultListener == null) ? (ITestResultListener) new DefaultTestResultListener(stderr)
															  : testResultListener;
		
		if(frameObserver == null){
			if(profile){
				setFrameObserver(new ProfileFrameObserver(this));
			} else if(coverage){
				setFrameObserver(new CoverageFrameObserver(this));
			} else if(debug){
				setFrameObserver(new DebugFrameObserver(this));
			} else if(trace){
					setFrameObserver(new CallTraceObserver(this));
			} else if(debugRVM){
				setFrameObserver(new RVMTrackingObserver(this));
			} else {
				setFrameObserver(NullFrameObserver.getInstance());
			}
		} else {
			setFrameObserver(frameObserver);
		}
		
		parsingTools = new ParsingTools(vf);
		createCaches(true);
	}
	
	// Cache related methods
	
	
	private void createCaches(boolean enabled){
		type2symbolCache = Caffeine.newBuilder()
//				.weakKeys()
			    .weakValues()
//			    .recordStats()
				.maximumSize(enabled ? type2symbolCacheSize : 0)
				.build();
		descendantDescriptorCache = Caffeine.newBuilder()
//				.weakKeys()
			    .weakValues()
//			    .recordStats()
				.maximumSize(enabled ? descendantDescriptorCacheSize : 0)
				.build();
		subtypeCache = Caffeine.newBuilder()
				.maximumSize(enabled ? subtypeCacheSize : 0)
//				.weakKeys()
			    .weakValues()
//			    .recordStats()
				.build();
		companionDefaultFunctionCache = Caffeine.newBuilder()
//				.weakKeys()
			    .weakValues()
//			    .recordStats()
				.maximumSize(enabled ? companionDefaultFunctionCacheSize : 0)
				.build();
		companionFieldDefaultFunctionCache = Caffeine.newBuilder()
//				.weakKeys()
			    .weakValues()
//			    .recordStats()
				.maximumSize(enabled ? companionFieldDefaultFunctionCacheSize : 0)
				.build();
//		parserCache = Caffeine.newBuilder()
////				.weakKeys()
//			    .weakValues()
////			    .recordStats()
//				.maximumSize(enabled ? parserCacheSize : 0)
//				.build();
		
		parsedModuleCache = Caffeine.newBuilder()
//				.weakKeys()
			    .weakValues()
//			    .recordStats()
				.maximumSize(enabled ? parsedModuleCacheSize : 0)
				.build();
	}
	
	public void clearCaches(){
		createCaches(true);
	}
	
	public void noCaches(){
		createCaches(false);
	}
	
	public void printCacheStat(String name, Cache<?,?> cache){
		CacheStats s = cache.stats();
		System.out.printf(
				//"%35s: %f (ALP) %d (EV) %d (HC) %f (HR) %d (LC) %d (LFC) %f (LFR) %d (LSC) %d (MC) %f (MR) %d (RC)\n",
				"%35s: %12.0f (ALP) %f (HR) %d (RC)\n",
				name,
				s.averageLoadPenalty(),
				//s.evictionCount(),
				//s.hitCount(),
				s.hitRate(),
//				s.loadCount(),
//				s.loadFailureCount(),
//				s.loadFailureRate(),
//				s.loadSuccessCount(),
				//s.missCount(),
				//s.missRate(),
				s.requestCount());	
	}
	
	public void printCacheStats(){
	
		printCacheStat("type2symbolCache", type2symbolCache);
		printCacheStat("descendantDescriptorCache", descendantDescriptorCache);
		printCacheStat("subtypeCache", subtypeCache);
		printCacheStat("companionDefaultFunctionCache", companionDefaultFunctionCache);
		printCacheStat("companionFieldDefaultFunctionCache", companionFieldDefaultFunctionCache);
//		printCacheStat("parserCache", parserCache);
		printCacheStat("parsedModuleCache", parsedModuleCache);
	}

	public ParsingTools getParsingTools(){
		return parsingTools;
	}
	
//	public Cache<String,  Class<IGTD<IConstructor, ITree, ISourceLocation>>> getParserCache(){
//		return parserCache;
//	}
	
	public Cache<String, IValue> getParsedModuleCache() {
		return parsedModuleCache;
	}
	
	public IConstructor type2Symbol(final Type t){
		//return  RascalPrimitive.$type2symbol(t);
		return type2symbolCache.get(t, k -> RascalPrimitive.$type2symbol(t));
	}
	
	Cache<IString, DescendantDescriptor> getDescendantDescriptorCache() {
		return descendantDescriptorCache;
	}
	
	public boolean isSubtypeOf(Type t1, Type t2){
		//return t1.isSubtypeOf(t2);
		Type[] key = new Type[] { t1, t2};
		
		return subtypeCache.get(key, k -> t1.isSubtypeOf(t2));
	}
	
	public Function getCompanionDefaultsFunction(String name, Type ftype){
		String key = name + ftype;
		
		//return  rvm.getCompanionDefaultsFunction(name, ftype);
		
		Function result = companionDefaultFunctionCache.get(key, k -> rvm.getCompanionDefaultsFunction(name, ftype));
		//System.err.println("RascalExecutionContext.getCompanionDefaultsFunction: " + key + " => " + result.name);
		return result;
	}
	
	public Function getCompanionFieldDefaultFunction(Type adtType, String fieldName){
		//return rvm.getCompanionFieldDefaultFunction(adtType, fieldName);
		
		String key = adtType.toString() + fieldName;
		Function result = companionFieldDefaultFunctionCache.get(key, k -> rvm.getCompanionFieldDefaultFunction(adtType, fieldName));
		return result;
	}
	
	public static IValue shareConstant(IValue c){
		return sharedConstantCache.get(c, k -> k);
	}
	
	public static Type shareTypeConstant(Type t){
		return sharedTypeConstantCache.get(t, k -> k);
	}
	
	public IValueFactory getValueFactory(){ return vf; }
	
	public IMap getSymbolDefinitions() { return symbol_definitions; }
	
	public TypeStore getTypeStore() { 
		return typeStore; 
	}
	
	boolean getDebug() { return debug; }
	
	IFrameObserver getFrameObserver(){
		return frameObserver;
	}
	
	void setFrameObserver(IFrameObserver observer){
		frameObserver = observer;
	}
	
	boolean getDebugRVM() { return debugRVM; }
	
	boolean getTestSuite() { return testsuite; }
	
	boolean getProfile(){ return profile; }
	
	boolean getCoverage(){ return coverage; }
	
	boolean getJVM() { return jvm; }
	
	boolean getTrace() { return trace; }
	
	public RVMCore getRVM(){ return rvm; }
	
	protected void setRVM(RVMCore rvmCore){ 
		this.rvm = rvmCore;
		if(frameObserver != null){
			frameObserver.setRVM(rvmCore);
		}
	}
	
	public Map<IValue, IValue> getModuleVariables(){
		return moduleVariables;
	}
	
	void setModuleVariables(Map<IValue, IValue> moduleVariables){
		this.moduleVariables = moduleVariables;
	}
	
	public void addClassLoader(ClassLoader loader) {
		// later loaders have precedence
		classLoaders.add(0, loader);
	}
	
	List<ClassLoader> getClassLoaders() { return classLoaders; }
	
	IRascalMonitor getMonitor() {return monitor;}
	
	void setMonitor(IRascalMonitor monitor) {
		this.monitor = monitor;
	}
	
	public PrintWriter getStdErr() { return stderr; }
	
	public PrintWriter getStdOut() { return stdout; }
	
	Configuration getConfiguration() { return config; }
	
	ITestResultListener getTestResultListener() { return testResultListener; }
	
	public String getCurrentModuleName(){ return currentModuleName; }
	
	public void setCurrentModuleName(String moduleName) { currentModuleName = moduleName; }
	
	public Stack<String> getIndentStack() { return indentStack; }
	
	StringBuilder getTemplateBuilder() { return templateBuilder; }
	
	void setTemplateBuilder(StringBuilder sb) { templateBuilder = sb; }
	
	Stack<StringBuilder> getTemplateBuilderStack() { return  templateBuilderStack; }
	
	IListWriter getTestResults() { return test_results; }
	
	void setTestResults(IListWriter writer) { test_results = writer; }
	
	boolean bootstrapParser(String moduleName){
		if(moduleTags != null){
			IMap tags = (IMap) moduleTags.get(vf.string(moduleName));
			if(tags != null)
				return tags.get(vf.string("bootstrapParser")) != null;
		}
		return false;
	}
	
	public int endJob(boolean succeeded) {
		if (monitor != null)
			return monitor.endJob(succeeded);
		return 0;
	}
	
	public void event(int inc) {
		if (monitor != null)
			monitor.event(inc);
	}
	
	public void event(String name, int inc) {
		if (monitor != null)
			monitor.event(name, inc);
	}

	public void event(String name) {
		if (monitor != null)
			monitor.event(name);
	}

	public void startJob(String name, int workShare, int totalWork) {
		if (monitor != null){
			monitor.startJob(name, workShare, totalWork);
		} else {
			stdout.println(name);
			stdout.flush();
		}
	}
	
	public void startJob(String name, int totalWork) {
		if (monitor != null)
			monitor.startJob(name, totalWork);
	}
	
	public void startJob(String name) {
		if (monitor != null){
			monitor.startJob(name);
		} else {
			stdout.println(name);
			stdout.flush();
		}
	}
		
	public void todo(int work) {
		if (monitor != null)
			monitor.todo(work);
	}
	
	@Override
	public boolean isCanceled() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void warning(String message, ISourceLocation src) {
		stdout.println("Warning: " + message);
		stdout.flush();
	}

	public RascalSearchPath getRascalSearchPath() { 
		return rascalSearchPath; 
	}
	
	private void addRascalSearchPathContributor(IRascalSearchPathContributor contrib) {
		rascalSearchPath.addPathContributor(contrib);
	}
	
	private void addRascalSearchPath(final ISourceLocation uri) {
		rascalSearchPath.addPathContributor(new URIContributor(uri));
	}
	/**
	 * Source location resolvers map user defined schemes to primitive schemes
	 */
	private final HashMap<String, ICallableValue> sourceResolvers = new HashMap<String, ICallableValue>();
	
	/**
	 * Register a source resolver for a specific scheme. Will overwrite the previously
	 * registered source resolver for this scheme.
	 * 
	 * @param scheme   intended be a scheme name without + or :
	 * @param function a Rascal function of type `loc (loc)`
	 */
	public void registerSourceResolver(String scheme, ICallableValue function) {
		sourceResolvers.put(scheme, function);
	}
	
	public ISourceLocation resolveSourceLocation(ISourceLocation loc) {
		String scheme = loc.getScheme();
		int pos;
		
		ICallableValue resolver = sourceResolvers.get(scheme);
		if (resolver == null) {
			for (char sep : new char[] {'+',':'}) {
				pos = scheme.indexOf(sep);
				if (pos != -1) {
					scheme = scheme.substring(0, pos);
				}
			}

			resolver = sourceResolvers.get(scheme);
			if (resolver == null) {
				return loc;
			}
		}
		
		Type[] argTypes = new Type[] { TypeFactory.getInstance().sourceLocationType() };
		IValue[] argValues = new IValue[] { loc };
		
		return (ISourceLocation) resolver.call(argTypes, argValues, null).getValue();
	}
	
//	void registerCommonSchemes(){
//		addRascalSearchPath(URIUtil.rootLocation("test-modules"));
//		addRascalSearchPathContributor(StandardLibraryContributor.getInstance());
//		addRascalSearchPath(URIUtil.rootLocation("courses"));
//	}
}
