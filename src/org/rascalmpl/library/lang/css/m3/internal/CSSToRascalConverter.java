package org.rascalmpl.library.lang.css.m3.internal;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.library.lang.java.m3.internal.IValueList;
import org.rascalmpl.value.IConstructor;
import org.rascalmpl.value.IList;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;
import org.rascalmpl.value.exceptions.FactTypeUseException;
import org.rascalmpl.value.type.TypeFactory;
import org.rascalmpl.value.type.TypeStore;
import org.rascalmpl.values.ValueFactoryFactory;

public class CSSToRascalConverter {

	protected static final IValueFactory values = ValueFactoryFactory.getValueFactory();
	protected static final TypeFactory TF = TypeFactory.getInstance();

	private static final String DATATYPE_RASCAL_AST_TYPE_NODE = "Type";
	private static final String DATATYPE_RASCAL_AST_MODIFIER_NODE = "Modifier";
	private static final String DATATYPE_RASCAL_AST_DECLARATION_NODE = "Declaration";
	private static final String DATATYPE_RASCAL_AST_EXPRESSION_NODE = "Expression";
	private static final String DATATYPE_RASCAL_AST_STATEMENT_NODE = "Statement";
	private static final String DATATYPE_RASCAL_MESSAGE = "Message";
	private static final String DATATYPE_RASCAL_MESSAGE_ERROR = "error";

	private final org.rascalmpl.value.type.Type DATATYPE_RASCAL_AST_DECLARATION_NODE_TYPE;
	private final org.rascalmpl.value.type.Type DATATYPE_RASCAL_AST_EXPRESSION_NODE_TYPE;
	private final org.rascalmpl.value.type.Type DATATYPE_RASCAL_AST_STATEMENT_NODE_TYPE;
	protected static org.rascalmpl.value.type.Type DATATYPE_RASCAL_AST_TYPE_NODE_TYPE;
	protected static org.rascalmpl.value.type.Type DATATYPE_RASCAL_AST_MODIFIER_NODE_TYPE;

	protected static org.rascalmpl.value.type.Type DATATYPE_RASCAL_MESSAGE_DATA_TYPE;
	protected static org.rascalmpl.value.type.Type DATATYPE_RASCAL_MESSAGE_ERROR_NODE_TYPE;

	private IEvaluatorContext eval;
	
	protected final TypeStore typeStore;
	protected final Map<String, ISourceLocation> locationCache;

	CSSToRascalConverter(final TypeStore typeStore, Map<String, ISourceLocation> cache, IEvaluatorContext eval) {
		this.typeStore = typeStore;
		this.locationCache = cache;
		this.eval = eval;

		CSSToRascalConverter.DATATYPE_RASCAL_AST_TYPE_NODE_TYPE = this.typeStore.lookupAbstractDataType(DATATYPE_RASCAL_AST_TYPE_NODE);
		
		eval.getStdOut().println("DATATYPE_RASCAL_AST_TYPE_NODE: "+DATATYPE_RASCAL_AST_TYPE_NODE);
		eval.getStdOut().println("DATATYPE_RASCAL_AST_TYPE_NODE_TYPE: "+CSSToRascalConverter.DATATYPE_RASCAL_AST_TYPE_NODE_TYPE);
		
		CSSToRascalConverter.DATATYPE_RASCAL_AST_MODIFIER_NODE_TYPE = this.typeStore
				.lookupAbstractDataType(DATATYPE_RASCAL_AST_MODIFIER_NODE);
		this.DATATYPE_RASCAL_AST_DECLARATION_NODE_TYPE = typeStore
				.lookupAbstractDataType(DATATYPE_RASCAL_AST_DECLARATION_NODE);
		this.DATATYPE_RASCAL_AST_EXPRESSION_NODE_TYPE = typeStore
				.lookupAbstractDataType(DATATYPE_RASCAL_AST_EXPRESSION_NODE);
		this.DATATYPE_RASCAL_AST_STATEMENT_NODE_TYPE = typeStore
				.lookupAbstractDataType(DATATYPE_RASCAL_AST_STATEMENT_NODE);
		CSSToRascalConverter.DATATYPE_RASCAL_MESSAGE_DATA_TYPE = typeStore
				.lookupAbstractDataType(DATATYPE_RASCAL_MESSAGE);
		CSSToRascalConverter.DATATYPE_RASCAL_MESSAGE_ERROR_NODE_TYPE = typeStore
				.lookupConstructor(DATATYPE_RASCAL_MESSAGE_DATA_TYPE, DATATYPE_RASCAL_MESSAGE_ERROR).iterator().next();
	}

	protected IValue[] removeNulls(IValue... withNulls) {
		List<IValue> withOutNulls = new ArrayList<IValue>();
		for (IValue child : withNulls) {
			if (!(child == null)) {
				withOutNulls.add(child);
			}
		}
		return withOutNulls.toArray(new IValue[withOutNulls.size()]);
	}

	protected IValue constructDeclarationNode(String constructor, IValue... children) {
		eval.getStdOut().println("constructDeclarationNode: "+constructor);
		org.rascalmpl.value.type.Type args = TF.tupleType(removeNulls(children));
		eval.getStdOut().println("args: "+args);
		org.rascalmpl.value.type.Type constr = typeStore.lookupConstructor(DATATYPE_RASCAL_AST_DECLARATION_NODE_TYPE,
				constructor, args);		
		eval.getStdOut().println("constructDeclarationNode constr: "+constr);
		return values.constructor(constr, removeNulls(children));
	}

	protected IValue constructExpressionNode(String constructor, IValue... children) {
		eval.getStdOut().println("constructExpressionNode: "+constructor);
		org.rascalmpl.value.type.Type args = TF.tupleType(removeNulls(children));
		eval.getStdOut().println("args: "+args);
		org.rascalmpl.value.type.Type constr = typeStore.lookupConstructor(DATATYPE_RASCAL_AST_EXPRESSION_NODE_TYPE,
				constructor, args);
		eval.getStdOut().println("constructExpressionNode constr: "+constr);
		return values.constructor(constr, removeNulls(children));
	}

	protected IValue constructStatementNode(String constructor, IValue... children) {
		eval.getStdOut().println("constructStatementNode: "+constructor);
		org.rascalmpl.value.type.Type args = TF.tupleType(removeNulls(children));
		eval.getStdOut().println("args: "+args);
		org.rascalmpl.value.type.Type constr = typeStore.lookupConstructor(DATATYPE_RASCAL_AST_STATEMENT_NODE_TYPE,
				constructor, args);
		
		eval.getStdOut().println("constructStatementNode constr: "+constr);
		
		return values.constructor(constr, removeNulls(children));
	}

	protected IValue constructTypeNode(String constructor, IValue... children) {
		eval.getStdOut().println("constructTypeNode: "+constructor);
		
		org.rascalmpl.value.type.Type args = TF.tupleType(removeNulls(children));
		
		eval.getStdOut().println("args: "+args);
		
		org.rascalmpl.value.type.Type constr = typeStore.lookupConstructor(DATATYPE_RASCAL_AST_TYPE_NODE_TYPE,
				constructor, args);		
		
		eval.getStdOut().println("constructTypeNode constr: "+constr);
		
		return values.constructor(constr, removeNulls(children));
	}

	protected IValue setAnnotation(String annoName, IValue value, IValue annoValue) {
		if (value.getType().declaresAnnotation(this.typeStore, annoName)) {
			return ((IConstructor) value).asAnnotatable().setAnnotation(annoName, annoValue);
		}
		return null;
	}

	protected IValue setAnnotation(String annoName, IValue value, IValueList annoList) {
		IList annos = (IList) annoList.asList();
		if (annoList != null && value.getType().declaresAnnotation(this.typeStore, annoName)
				&& !annos.isEmpty()) {
			return ((IConstructor) value).asAnnotatable().setAnnotation(annoName, annos);
		}
		return null;
	}
}
