package org.rascalmpl.library.lang.css.m3.internal;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.library.lang.java.m3.internal.IValueList;
import org.rascalmpl.value.IConstructor;
import org.rascalmpl.value.IList;
import org.rascalmpl.value.IListWriter;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;
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

	protected IListWriter messages;
	protected IValue ownValue;

	private IEvaluatorContext eval;

	protected final TypeStore typeStore;
	protected final Map<String, ISourceLocation> locationCache;

	public CSSToRascalConverter(final TypeStore typeStore, Map<String, ISourceLocation> cache, IEvaluatorContext eval) {
		this.typeStore = typeStore;
		this.locationCache = cache;
		this.eval = eval;
		
		messages = values.listWriter();

		CSSToRascalConverter.DATATYPE_RASCAL_AST_TYPE_NODE_TYPE = this.typeStore
				.lookupAbstractDataType(DATATYPE_RASCAL_AST_TYPE_NODE);
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
		org.rascalmpl.value.type.Type args = TF.tupleType(removeNulls(children));
		org.rascalmpl.value.type.Type constr = typeStore.lookupConstructor(DATATYPE_RASCAL_AST_DECLARATION_NODE_TYPE,
				constructor, args);
		return values.constructor(constr, removeNulls(children));
	}

	protected IValue constructExpressionNode(String constructor, IValue... children) {
		org.rascalmpl.value.type.Type args = TF.tupleType(removeNulls(children));
		org.rascalmpl.value.type.Type constr = typeStore.lookupConstructor(DATATYPE_RASCAL_AST_EXPRESSION_NODE_TYPE,
				constructor, args);
		return values.constructor(constr, removeNulls(children));
	}

	protected IValue constructStatementNode(String constructor, IValue... children) {
		org.rascalmpl.value.type.Type args = TF.tupleType(removeNulls(children));
		org.rascalmpl.value.type.Type constr = typeStore.lookupConstructor(DATATYPE_RASCAL_AST_STATEMENT_NODE_TYPE,
				constructor, args);
		return values.constructor(constr, removeNulls(children));
	}

	protected IValue constructTypeNode(String constructor, IValue... children) {
		org.rascalmpl.value.type.Type args = TF.tupleType(removeNulls(children));
		org.rascalmpl.value.type.Type constr = typeStore.lookupConstructor(DATATYPE_RASCAL_AST_TYPE_NODE_TYPE,
				constructor, args);
		return values.constructor(constr, removeNulls(children));
	}
	
	protected IConstructor constructModifierNode(String constructor, IValue... children) {
		org.rascalmpl.value.type.Type args = TF.tupleType(removeNulls(children));
		org.rascalmpl.value.type.Type constr = typeStore.lookupConstructor(DATATYPE_RASCAL_AST_MODIFIER_NODE_TYPE,
				constructor, args);
		return values.constructor(constr, removeNulls(children));
	}

	public IValue getValue() {
		return this.ownValue;
	}

	protected void setAnnotation(String annoName, IValue annoValue) {
		if (this.ownValue == null) {
			return;
		}
		if (annoValue != null && ownValue.getType().declaresAnnotation(this.typeStore, annoName)) {
			ownValue = ((IConstructor) ownValue).asAnnotatable().setAnnotation(annoName, annoValue);
		}
	}
	
//	protected void insertCompilationUnitMessages(boolean insertErrors, IList otherMessages) {
//		org.rascalmpl.value.type.Type args = TF.tupleType(TF.stringType(), TF.sourceLocationType());
//
//		IValueList result = new IValueList(values);
//
//		if (otherMessages != null) {
//			for (IValue message : otherMessages) {
//				result.add(message);
//			}
//		}
//
//		if (insertErrors) {
//			int i;
//
//			IProblem[] problems = null;//compilUnit.getProblems();
//			for (i = 0; i < problems.length; i++) {
//				int offset = problems[i].getSourceStart();
//				int length = problems[i].getSourceEnd() - offset + 1;
//				int sl = problems[i].getSourceLineNumber();
//				ISourceLocation pos = values.sourceLocation(loc, offset, length, sl, sl, 0, 0);
//				org.rascalmpl.value.type.Type constr;
//				if (problems[i].isError()) {
//					constr = typeStore.lookupConstructor(this.typeStore.lookupAbstractDataType("Message"), "error",
//							args);
//				} else {
//					constr = typeStore.lookupConstructor(this.typeStore.lookupAbstractDataType("Message"), "warning",
//							args);
//				}
//				result.add(values.constructor(constr, values.string(problems[i].getMessage()), pos));
//			}
//		}
//		setAnnotation("messages", result.asList());
//	}

	protected void setAnnotation(String annoName, IValueList annoList) {
		IList annos = (IList) annoList.asList();
		if (this.ownValue == null) {
			return;
		}
		if (annoList != null && this.ownValue.getType().declaresAnnotation(this.typeStore, annoName)
				&& !annos.isEmpty()) {
			this.ownValue = ((IConstructor) this.ownValue).asAnnotatable().setAnnotation(annoName, annos);
		}
	}
}
