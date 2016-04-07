package org.rascalmpl.library.lang.css.m3.internal;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.eclipse.jdt.core.dom.AST;
import org.eclipse.jdt.core.dom.BodyDeclaration;
import org.rascalmpl.library.lang.java.m3.internal.IValueList;
import org.rascalmpl.value.IConstructor;
import org.rascalmpl.value.IList;
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

	protected final TypeStore typeStore;
	protected final Map<String, ISourceLocation> locationCache;
	protected IValue ownValue;

	CSSToRascalConverter(final TypeStore typeStore, Map<String, ISourceLocation> cache) {
		this.typeStore = typeStore;
		this.locationCache = cache;

		DATATYPE_RASCAL_AST_TYPE_NODE_TYPE = this.typeStore.lookupAbstractDataType(DATATYPE_RASCAL_AST_TYPE_NODE);
		DATATYPE_RASCAL_AST_MODIFIER_NODE_TYPE = this.typeStore
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

	protected IValueList parseModifiers(IValue node) {
		IValueList list = new IValueList(values);
		list.add(node);
		return list;
	}

	protected void setAnnotation(String annoName, IValue annoValue) {
		if (this.ownValue == null) {
			return;
		}
		if (annoValue != null && ownValue.getType().declaresAnnotation(this.typeStore, annoName)) {
			ownValue = ((IConstructor) ownValue).asAnnotatable().setAnnotation(annoName, annoValue);
		}
	}

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
