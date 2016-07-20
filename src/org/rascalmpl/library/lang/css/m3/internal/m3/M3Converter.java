package org.rascalmpl.library.lang.css.m3.internal.m3;

import java.util.List;
import java.util.Stack;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.library.lang.css.m3.internal.CSSToRascalConverter;
import org.rascalmpl.library.lang.java.m3.internal.IValueList;
import org.rascalmpl.value.IConstructor;
import org.rascalmpl.value.IList;
import org.rascalmpl.value.ISetWriter;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.IString;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.type.TypeFactory;
import org.rascalmpl.value.type.TypeStore;

import cz.vutbr.web.css.CodeLocation;
import cz.vutbr.web.css.StyleSheet;
import cz.vutbr.web.csskit.CSSError;

public abstract class M3Converter extends CSSToRascalConverter {
	
	protected StyleSheet stylesheet;

	private static final String DATATYPE_M3_NODE = "M3";
	private final org.rascalmpl.value.type.Type DATATYPE_M3_NODE_TYPE;
	private final org.rascalmpl.value.type.Type DATATYPE_TYPESYMBOL;

	private static final org.rascalmpl.value.type.Type locType = TF.sourceLocationType();
	private static final org.rascalmpl.value.type.Type m3TupleType = TF.tupleType(locType, locType);
	private final org.rascalmpl.value.type.Type m3LOCModifierType;
	private final org.rascalmpl.value.type.Type m3LOCTypeType;

	protected final Stack<ISourceLocation> scopeManager = new Stack<ISourceLocation>();

	protected ISetWriter uses; // @font-face and @keyframes 
	protected ISetWriter declarations; // Everything which is declared
	protected ISetWriter containment; // Rules within declarations and declarations within viewport or media at-rules
	protected ISetWriter documentation; // Comments
	protected ISetWriter modifiers; // Such as the !important tag
	protected ISetWriter names; // Names of classes and id's
	protected ISetWriter invocation; // Could be used later for animation functions?
	
	protected final org.rascalmpl.value.type.Type CONSTRUCTOR_M3;
	
	public IEvaluatorContext eval;
	
	public ISourceLocation createLocation(ISourceLocation loc, CodeLocation location) {
		return values.sourceLocation(loc, 
				location.getOffset(), 
				location.getLength(), 
				location.getStartLine(),
				location.getEndLine(), 
				location.getStartColumn(), 
				location.getEndColumn());
	}

	@SuppressWarnings("deprecation")
	public M3Converter(final TypeStore typeStore, java.util.Map<String, ISourceLocation> cache, ISourceLocation loc, IEvaluatorContext eval) {
		super(typeStore, cache, loc, eval);
		this.eval = eval;
		//eval.getStdOut().println("M3Converter");
		
		this.DATATYPE_M3_NODE_TYPE = this.typeStore.lookupAbstractDataType(DATATYPE_M3_NODE);
		TypeFactory tf = TypeFactory.getInstance();

		this.CONSTRUCTOR_M3 = typeStore.lookupConstructor(DATATYPE_M3_NODE_TYPE, "m3",
				tf.tupleType(tf.sourceLocationType()));
				
		this.DATATYPE_TYPESYMBOL = typeStore.lookupAbstractDataType("TypeSymbol");
		uses = values.relationWriter(m3TupleType);
		declarations = values.relationWriter(m3TupleType);
		containment = values.relationWriter(m3TupleType);
		m3LOCModifierType = TF.tupleType(locType, DATATYPE_RASCAL_AST_MODIFIER_NODE_TYPE);
		modifiers = values.relationWriter(m3LOCModifierType);
		m3LOCTypeType = TF.tupleType(locType, locType);
		documentation = values.relationWriter(m3TupleType);
		names = values.relationWriter(TF.tupleType(TF.stringType(), locType));
		invocation = values.relationWriter(m3TupleType);
	}

	public IValue getModel(boolean insertErrors, ISourceLocation loc) {
		ownValue = values.constructor(CONSTRUCTOR_M3, loc);
		
		setAnnotation("declarations", declarations.done());
		setAnnotation("uses", uses.done());
		setAnnotation("containment", containment.done());
		setAnnotation("invocation", invocation.done());
		setAnnotation("modifiers", modifiers.done());
		setAnnotation("documentation", documentation.done());
		setAnnotation("names", names.done());
		
		insertCompilationUnitMessages(insertErrors, messages.done());
		
		return ownValue;
	}

	public ISourceLocation getParent() {
		return scopeManager.peek();
	}

	public void insert(ISetWriter relW, IValue lhs, IValue rhs) {
		if ((isValid((ISourceLocation) lhs) && isValid((ISourceLocation) rhs))) {
			relW.insert(values.tuple(lhs, rhs));
		}
	}

	public void insert(ISetWriter relW, IValue lhs, IValueList rhs) {
		for (IValue oneRHS : (IList) rhs.asList())
			if (lhs.getType().isString() || (isValid((ISourceLocation) lhs) && isValid((ISourceLocation) oneRHS)))
				insert(relW, lhs, oneRHS);
	}

	public void insert(ISetWriter relW, IString lhs, IValue rhs) {
		if (isValid((ISourceLocation) rhs)) {
			relW.insert(values.tuple(lhs, rhs));
		}
	}

	public void insert(ISetWriter relW, IValue lhs, IConstructor rhs) {
		if (isValid((ISourceLocation) lhs) && rhs != null) {
			relW.insert(values.tuple(lhs, rhs));
		}
	}

	protected boolean isValid(ISourceLocation binding) {
		return binding != null && !(binding.getScheme().equals("unknown") || binding.getScheme().equals("unresolved"));
	}

	protected void insertCompilationUnitMessages(boolean insertErrors, IList otherMessages) {
		org.rascalmpl.value.type.Type args = TF.tupleType(TF.stringType(), TF.sourceLocationType());

		IValueList result = new IValueList(values);

		if (otherMessages != null) {
			for (IValue message : otherMessages) {
				result.add(message);
			}
		}
		
		if (insertErrors) {
			int i;
			List<CSSError> problems = stylesheet.getCSSErrors();
			for (i = 0; i < problems.size(); i++) {
				ISourceLocation pos = createLocation(loc, problems.get(i).getLocation());
				
				org.rascalmpl.value.type.Type constr;
				constr = typeStore.lookupConstructor(this.typeStore.lookupAbstractDataType("Message"), "error", args);
				result.add(values.constructor(constr, values.string(problems.get(i).getMessage()), pos));
			}
		}
		setAnnotation("messages", result.asList());
	}
}
