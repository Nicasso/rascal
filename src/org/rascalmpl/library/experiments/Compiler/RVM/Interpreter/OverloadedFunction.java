package org.rascalmpl.library.experiments.Compiler.RVM.Interpreter;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.nustaq.serialization.FSTBasicObjectSerializer;
import org.nustaq.serialization.FSTClazzInfo;
import org.nustaq.serialization.FSTClazzInfo.FSTFieldInfo;
import org.nustaq.serialization.FSTObjectInput;
import org.nustaq.serialization.FSTObjectOutput;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;
import org.rascalmpl.value.type.Type;
import org.rascalmpl.value.type.TypeStore;
import org.rascalmpl.values.uptr.RascalValueFactory;

/**
 * Represent one overloaded function given
 * - a list of function alternatives
 * - a list of constructor alternatives
 * - a scope
 * 
 * An overloaded function is created during loading and is consulted at run-time
 * to create an OverloadedFunctionInstance for each specific call.
 *
 */
public class OverloadedFunction implements Serializable {
	
	private static final long serialVersionUID = -5235184427484318482L;
	final String name;
	final Type funType;
	int[] functions;
	final int[] constructors;
	final String funIn;
	int scopeIn = -1;
	boolean allConcreteFunctionArgs = false;
	boolean allConcreteConstructorArgs = false;
	HashMap<Integer, int[]> filteredFunctions;		// Functions and constructors filtered on fingerprint of first argument
	HashMap<Integer, int[]> filteredConstructors;
	
	public OverloadedFunction(String name, Type funType, final int[] functions, final int[] constructors, final String funIn) {
		if(funIn == null){
			System.out.println("OverloadedFunction: funIn is null");
		}
		this.name = name;
		this.funType = funType;
		this.functions = functions;
		this.constructors = constructors;
		this.funIn = funIn;
	}
	
	public OverloadedFunction(String name, Type funType, int[] functions, int[] constructors, String funIn,
			int scopeIn, boolean allConcreteFunctionArgs, boolean allConcreteConstructorArgs,
			HashMap<Integer, int[]> filteredFunctions, HashMap<Integer, int[]> filteredConstructors) {
		this.name = name;
		this.funType = funType;
		this.functions = functions;
		this.constructors = constructors;
		this.funIn = funIn;
		this.scopeIn = scopeIn;
		this.allConcreteFunctionArgs = allConcreteFunctionArgs;
		this.allConcreteConstructorArgs = allConcreteConstructorArgs;
		this.filteredFunctions = filteredFunctions;
		this.filteredConstructors = filteredConstructors;
	}

	public boolean matchesNameAndSignature(String name, Type funType){
		return this.name.equals(name) && this.funType.comparable(funType);
	}
	
	public String getName() {
	    return name;
	}
	
	public int getArity(){
		return funType.getArity();
	}
	
	public void  finalize(final Map<String, Integer> functionMap, ArrayList<Function> functionStore, Map<Integer, Integer> indexMap){
		if(funIn.length() > 0){ // != null) {
			Integer si = functionMap.get(funIn);
			if(si == null){		// Give up, containing scope is not included in final RVM image created by loader
				return;
			}
			this.setScopeIn(si);
		}
		if(indexMap != null){
			int nelems = 0;
			for(int i = 0; i < functions.length; i++){
				Integer newIndex = indexMap.get(functions[i]);
				if(newIndex != null){
					functions[nelems++] = newIndex;
				}
			}
			if(functions.length > nelems){
				int[] newFunctions = new int[nelems];
				for(int i = 0; i < nelems; i++){
					newFunctions[i] = functions[i];
				}
				functions = newFunctions;
			}
		}
		// TODO: temp consistency tests
		for(int fid : functions){
			if(fid < 0 || fid >= functionStore.size()){
				System.err.println("OverloadedFunction: function outside functionStore: " + fid);
			}
		}
//		for(int cid : constructors){
//			if(cid < 0 || cid >= functionStore.size()){
//				System.err.println("OverloadedFunction: constructor outside functionStore: " + cid);
//			}
//		}
		filter(functionStore);
	}
	
	void printArray(int[] a){
		System.out.print("[ ");for(int i : functions) System.out.print(i + " "); System.out.println("]");
	}
	
	boolean compareIntArrays(int[] a, int[] b){
		if(a == null && b != null){
			System.out.println("Array a null, b is not null");
			return false;
		}
		if(a != null && b == null){
			System.out.println("Array a not null, b is null");
			return false;
		}
		if(a == null && b == null){
			System.out.println("Array a  null, b is null");
			return false;
		}
		if(a.length != b.length){
			System.out.println("Different length: " + a.length + " vs " + b.length);
		}
		for(int i = 0; i < a.length; i++){
			if(a[i] != b[i]){
				System.out.println("Differ at index " + i);
				return false;
			}
		}
		return true;
	}
	boolean compareIntMaps(HashMap<Integer, int[]> a, HashMap<Integer, int[]> b){
		if(a.size() != b.size()){
			System.out.println("Different length: " + a.size() + " vs " + b.size());
		}
		for(int i : a.keySet()){
			if(!compareIntArrays(a.get(i), b.get(i))){
				System.out.println("Maps differ at index " + i);
				return false;
			}
		}
		return true;
	}
	
	public boolean comparable(OverloadedFunction other){
		if(!compareIntArrays(functions, other.functions)){
			System.out.println("functions differ: " + functions + " vs " + other.functions);
			printArray(functions);	System.out.print(" vs "); printArray(other.functions);
			return false;
		}
		if(!compareIntArrays(constructors, other.constructors)){
			System.out.println("constructors differ: " + constructors + " vs " + other.constructors);
			printArray(constructors);	System.out.print(" vs "); printArray(other.constructors);
			return false;
		}
		if(!funIn.equals(other.funIn)){
			System.out.println("funIn differ");
			return false;
		}
		if(getScopeIn() != other.getScopeIn()){
			System.out.println("scopeIn differ");
			return false;
		}
		if(allConcreteFunctionArgs != other.allConcreteFunctionArgs){
			System.out.println("allConcreteFunctionArgs differ");
			return false;
		}
		if(allConcreteConstructorArgs != other.allConcreteConstructorArgs){
			System.out.println("allConcreteConstructorArgs differ");
			return false;
		}
		if(filteredFunctions != null && other.filteredFunctions != null && !compareIntMaps(filteredFunctions, other.filteredFunctions)){
			System.out.println("filteredFunctions differ");
			return false;
		}
		if(filteredConstructors != null && other.filteredConstructors != null && !compareIntMaps(filteredConstructors, other.filteredConstructors)){
			System.out.println("filteredConstructors differ");
			return false;
		}
		return true;
	}
	
	/**
	 * Get the overloaded alternatives for this function given (first) actual parameter args0
	 * @param arg0	first actual parameter
	 * @return	list of overloadings
	 */
	public int[] getFunctions(Object arg0){
		if(functions.length <= 1 || !(arg0 instanceof IValue)){
			return functions;
		}

		int fp = ToplevelType.getFingerprint((IValue) arg0, allConcreteFunctionArgs);
		int[] funs = filteredFunctions.get(fp);
		return funs == null ? filteredFunctions.get(0) : funs;
	}
	
	/**
	 * Get the overloaded constructor alternatives for this function given (first) actual parameter args0
	 * @param arg0	first actual parameter
	 * @return	list of overloadings
	 * 
	 * Note: at the moment we do not (yet?) filter constructor alternatives
	 */
	public int[] getConstructors(Object arg0) {
			return constructors;
	}
	
	private void filter(ArrayList<Function> functionStore){
		filterFunctions(functionStore);
		//filterConstructors(rvm);
	}
	
	/**
	 * Preprocess all overloadings to make run-time lookup as fast as possible:
	 * - All overloads with the same fingerprint are collected and placed in a table.
	 * - All overloads that (a) map to fingerprint 0 (b) are a default functions are
	 *   are placed at the end of the list of alternatives for each fingerprint.
	 *   
	 * @param rvm	needed for access to the function declarations via rvm.functionStore
	 */
	private void filterFunctions(ArrayList<Function> functionStore){
		if(functions.length > 1){
			filteredFunctions = new HashMap<Integer,int[]>();
		} else {
			return;
		}
		// Determine whether all first arguments are concrete
		allConcreteFunctionArgs = true;
		HashMap<Integer, ArrayList<Integer>> filtered = new HashMap<Integer, ArrayList<Integer>>();
		for(int fid : functions){
			Function fdef = functionStore.get(fid);
			if(!fdef.concreteArg){
				allConcreteFunctionArgs = false;
			}
		}
		// Collect applicable functions per fingerprint
		for(int fid : functions){
			Function fdef = functionStore.get(fid);
			int fp = fdef.isDefault ? 0 : (allConcreteFunctionArgs ? fdef.concreteFingerprint : fdef.abstractFingerprint);
			ArrayList<Integer> alts = filtered.get(fp);
			if(alts == null){
				alts = new ArrayList<Integer>();
				filtered.put(fp,  alts);
			}
			alts.add(fid);
		}
		
		// Transform the table into one with the required values of type: int[]
		// On the fly attach all default functions to each entry
		ArrayList<Integer> defaults = filtered.get(0);
		if(defaults == null){
			defaults = new ArrayList<Integer>();
			filtered.put(0,  defaults);
		}
		int ndefaults = defaults.size();
		
		for(int fp : filtered.keySet()){
			ArrayList<Integer> alts = filtered.get(fp);
			int nalts = alts.size();
			int[] funs = new int[nalts + ndefaults];
			for(int i = 0; i < nalts; i++){
				funs[i] = alts.get(i);
			}
			for(int i = 0; i < ndefaults; i++){
				funs[nalts + i] = defaults.get(i);
			}
			filteredFunctions.put(fp, funs);
		}
	}
	
	// The next four members are needed by the bytecode generator.
	public int[] getFunctions() {
		return functions;
	}

	public int[] getConstructors() {
		return constructors;
	}
	
	public int getScope() {
		return getScopeIn() ;
	}
	
	public String getScopeFun() {
		return funIn ;
	}
	
	public String toString(){
		StringBuilder sb = new StringBuilder("Overloaded[" + name + ":" + funType + ":");
		if(functions.length > 0){
			sb.append("functions:");
			for(int i = 0; i < functions.length; i++){
				sb.append(" ").append(functions[i]);
			}
		}
		if(constructors.length > 0){
			if(functions.length > 0){
				sb.append("; ");
			}
			sb.append("constructors:");
			for(int i = 0; i < constructors.length; i++){
				sb.append(" ").append(constructors[i]);
			}
		}
		sb.append("]");
		return sb.toString();
	}

	public int getScopeIn() {
		return scopeIn;
	}

	public void setScopeIn(int scopeIn) {
		this.scopeIn = scopeIn;
	}

}


/**
 * FSTOverloadedFunctionSerializer: serializer for OverloadedFunction objects
 *
 */
class FSTOverloadedFunctionSerializer extends FSTBasicObjectSerializer {
	
	//private static IValueFactory vf;
	private static TypeStore store;

	public static void initSerialization(IValueFactory vfactory, TypeStore ts){
		//vf = vfactory;
		store = ts;
		store.extendStore(RascalValueFactory.getStore());
	}

	@Override
	public void writeObject(FSTObjectOutput out, Object toWrite,
			FSTClazzInfo clzInfo, FSTFieldInfo arg3, int arg4)
					throws IOException {
		
		OverloadedFunction ofun = (OverloadedFunction) toWrite;

		// String name;
		out.writeObject(ofun.name);

		// Type funType;
		out.writeObject(new FSTSerializableType(ofun.funType));
		
		// int[] functions;
		out.writeObject(ofun.functions);
		
		// final int[] constructors;
		out.writeObject(ofun.constructors);
		
		// final String funIn;
		out.writeObject(ofun.funIn);
		
		// private int scopeIn = -1;
		out.writeObject(ofun.scopeIn);
		
		// boolean allConcreteFunctionArgs = false;
		out.writeObject(ofun.allConcreteFunctionArgs);
		
		// boolean allConcreteConstructorArgs = false;
		out.writeObject(ofun.allConcreteConstructorArgs);
		
		// HashMap<Integer, int[]> filteredFunctions;
		out.writeObject(ofun.filteredFunctions);
		
		// HashMap<Integer, int[]> filteredConstructors;
		out.writeObject(ofun.filteredConstructors);
	}
	
	@Override
	public void readObject(FSTObjectInput in, Object toRead, FSTClazzInfo clzInfo, FSTClazzInfo.FSTFieldInfo referencedBy)
	{
	}
	
	@SuppressWarnings("unchecked")
	public Object instantiate(@SuppressWarnings("rawtypes") Class objectClass, FSTObjectInput in, FSTClazzInfo serializationInfo, FSTClazzInfo.FSTFieldInfo referencee, int streamPosition) throws ClassNotFoundException, IOException 
	{
		// String name;
		String name = (String) in.readObject();

		// Type funType;
		Type funType = (Type) in.readObject();
		
		// int[] functions;
		int[] functions = (int[]) in.readObject();
		
		
		// final int[] constructors;
		int[] constructors = (int[]) in.readObject();
		
		// final String funIn;
		 String funIn = (String) in.readObject();
		
		// private int scopeIn = -1;
		 int scopeIn = (Integer) in.readObject();
		
		// boolean allConcreteFunctionArgs = false;
		boolean allConcreteFunctionArgs = (Boolean) in.readObject();
		
		// boolean allConcreteConstructorArgs = false;
		boolean allConcreteConstructorArgs = (Boolean) in.readObject();
		
		// HashMap<Integer, int[]> filteredFunctions;
		HashMap<Integer, int[]> filteredFunctions = (HashMap<Integer, int[]>) in.readObject();
		
		// HashMap<Integer, int[]> filteredConstructors;
		
		HashMap<Integer, int[]> filteredConstructors = (HashMap<Integer, int[]>) in.readObject();
		
		OverloadedFunction ofun = new OverloadedFunction(name, funType, functions, constructors, funIn, scopeIn, allConcreteFunctionArgs, allConcreteConstructorArgs,
				filteredFunctions,filteredConstructors);
		return ofun;
	}
}

