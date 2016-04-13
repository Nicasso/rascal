package org.rascalmpl.library.lang.css.m3.internal.m3;

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

public abstract class M3Converter extends CSSToRascalConverter {

	private static final String DATATYPE_M3_NODE = "M3";
	private final org.rascalmpl.value.type.Type DATATYPE_M3_NODE_TYPE;
	private final org.rascalmpl.value.type.Type DATATYPE_TYPESYMBOL;

	private static final org.rascalmpl.value.type.Type locType = TF.sourceLocationType();
	private static final org.rascalmpl.value.type.Type m3TupleType = TF.tupleType(locType, locType);
	private final org.rascalmpl.value.type.Type m3LOCModifierType;
	private final org.rascalmpl.value.type.Type m3LOCTypeType;

	protected final Stack<ISourceLocation> scopeManager = new Stack<ISourceLocation>();

	protected ISetWriter uses; //@Font-face gets used
	protected ISetWriter declarations;//@Font-face gets declared maybe functions too
	protected ISetWriter containment;// rules within declarations and declarations within viewport or media at-rules
	protected ISetWriter documentation;// Comments
	protected ISetWriter modifiers;// The !important tag
	protected ISetWriter names;// Names of classes and id's
	protected ISetWriter invocation;// Could be used later for animation functions
	
	protected final org.rascalmpl.value.type.Type CONSTRUCTOR_M3;
	
	public IEvaluatorContext eval;

	@SuppressWarnings("deprecation")
	public M3Converter(final TypeStore typeStore, java.util.Map<String, ISourceLocation> cache, IEvaluatorContext eval) {
		super(typeStore, cache, eval);
		this.eval = eval;
		eval.getStdOut().println("M3Converter");
		
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
		
		//insertCompilationUnitMessages(insertErrors, messages.done());
		
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

}
