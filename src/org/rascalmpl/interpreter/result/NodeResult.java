/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:

 *   * Jurgen J. Vinju - Jurgen.Vinju@cwi.nl - CWI
 *   * Tijs van der Storm - Tijs.van.der.Storm@cwi.nl
 *   * Paul Klint - Paul.Klint@cwi.nl - CWI
 *   * Arnold Lankamp - Arnold.Lankamp@cwi.nl
*******************************************************************************/
package org.rascalmpl.interpreter.result;


import static org.rascalmpl.interpreter.result.ResultFactory.makeResult;

import java.util.Map;

import org.rascalmpl.ast.Name;
import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.interpreter.env.Environment;
import org.rascalmpl.interpreter.staticErrors.UndeclaredAnnotation;
import org.rascalmpl.interpreter.staticErrors.UnexpectedType;
import org.rascalmpl.interpreter.staticErrors.UnsupportedSubscriptArity;
import org.rascalmpl.interpreter.utils.Names;
import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;
import org.rascalmpl.value.IBool;
import org.rascalmpl.value.IInteger;
import org.rascalmpl.value.IListWriter;
import org.rascalmpl.value.INode;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.type.Type;
import org.rascalmpl.value.type.TypeFactory;

public class NodeResult extends ElementResult<INode> {

	public NodeResult(Type type, INode node, IEvaluatorContext ctx) {
		super(type, node, ctx);
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public Result<IBool> isKeyDefined(Result<?>[] subscripts) {
		if (subscripts.length != 1) { 
			throw new UnsupportedSubscriptArity(getType(), subscripts.length, ctx.getCurrentAST());
		} 
		Result<IValue> key = (Result<IValue>) subscripts[0];
		if (!key.getType().isSubtypeOf(getTypeFactory().integerType())) {
			throw new UnexpectedType(getTypeFactory().integerType(), key.getType(), ctx.getCurrentAST());
		}
		int idx = ((IInteger) key.getValue()).intValue();
		int len = getValue().arity();
		
		if ((idx >= 0 && idx >= len) || (idx < 0 && idx < -len)){
			return makeResult(getTypeFactory().boolType(), getValueFactory().bool(false), ctx);
		}
		
		return makeResult(getTypeFactory().boolType(), getValueFactory().bool(true), ctx);
	}

	@Override
	public <V extends IValue> Result<IBool> equals(Result<V> that) {
		return that.equalToNode(this);
	}

	@Override
	public <V extends IValue> Result<IBool> nonEquals(Result<V> that) {
		return that.nonEqualToNode(this);
	}

	@Override
	public <V extends IValue> LessThanOrEqualResult lessThanOrEqual(Result<V> result) {
		return result.lessThanOrEqualNode(this);
	}
	
	@Override
	public Result<IBool> is(Name name) {
		return ResultFactory.bool(getValue().getName().equals(Names.name(name)), ctx);
	}
	
	@Override
	public Result<IBool> has(Name name) {
		return isDefined(name);
	}
	
	@Override
	public Result<IBool> isDefined(Name name) {
		String sname = Names.name(name);
		return ResultFactory.bool(getValue().asWithKeywordParameters().hasParameter(sname), ctx);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <U extends IValue, V extends IValue> Result<U> subscript(Result<?>[] subscripts) {
		if (subscripts.length != 1) {
			throw new UnsupportedSubscriptArity(getType(), subscripts.length, ctx.getCurrentAST());
		}
		if (!((Result<IValue>)subscripts[0]).getType().isInteger()) {
			throw new UnexpectedType(getTypeFactory().integerType(), 
					((Result<IValue>)subscripts[0]).getType(), ctx.getCurrentAST());
		}
		IInteger index = ((IntegerResult)subscripts[0]).getValue();
		int idx = index.intValue();
		if (idx < 0){
			idx = idx + getValue().arity();
		}
		if ( (idx >= getValue().arity()) || (idx < 0)) {
			throw RuntimeExceptionFactory.indexOutOfBounds(index, ctx.getCurrentAST(), ctx.getStackTrace());
		}
		Type elementType = getTypeFactory().valueType();
		return makeResult(elementType, getValue().get(idx), ctx);
	}
	
	@Override
	public <U extends IValue, V extends IValue> Result<U> slice(Result<?> first, Result<?> second, Result<?> end) {
		return super.slice(first, second, end, getValue().arity());
	}
	
	public Result<IValue> makeSlice(int first, int second, int end){
		IListWriter w = getValueFactory().listWriter();
		int increment = second - first;
		if(first == end || increment == 0){
			// nothing to be done
		} else
		if(first <= end){
			for(int i = first; i >= 0 && i < end; i += increment){
				w.append(getValue().get(i));
			}
		} else {
			for(int j = first; j >= 0 && j > end && j < getValue().arity(); j += increment){
				w.append(getValue().get(j));
			}
		}
		TypeFactory tf = TypeFactory.getInstance();
		return makeResult(tf.listType(tf.valueType()), w.done(), ctx);
	}
	
	//////
	
	@Override
	protected LessThanOrEqualResult lessThanOrEqualNode(NodeResult that) {
	  INode left = that.getValue();
	  INode right = getValue();
	  
	  int compare = left.getName().compareTo(right.getName());
	  
	  if (compare <= -1) {
	    return new LessThanOrEqualResult(true, false, ctx);
	  }
	  
    if (compare >= 1){
      return new LessThanOrEqualResult(false, false, ctx);
    }
    
    // if the names are not ordered, then we order lexicographically on the arguments:
    
    int leftArity = left.arity();
    int rightArity = right.arity();
    
    if (leftArity < rightArity) {
    	return new LessThanOrEqualResult(true, false, ctx);
    }
    
    if (leftArity > rightArity) {
    	return new LessThanOrEqualResult(false, false, ctx);
    }
    
    for (int i = 0; i < Math.min(leftArity, rightArity); i++) {
    	IValue leftArg = left.get(i);
    	IValue rightArg = right.get(i);
    	LessThanOrEqualResult loe = makeResult(leftArg.getType(), leftArg, ctx).lessThanOrEqual(makeResult(rightArg.getType(), rightArg,ctx));

    	if (loe.getLess() && !loe.getEqual()) {
    		return new LessThanOrEqualResult(true, false, ctx);
    	}

    	if (!loe.getEqual()) { 
    		return new LessThanOrEqualResult(false, false, ctx);
    	}
    }
    
    if (!left.mayHaveKeywordParameters() && !right.mayHaveKeywordParameters()) {
    	if (left.asAnnotatable().hasAnnotations() || right.asAnnotatable().hasAnnotations()) {
    		// bail out 
    		return new LessThanOrEqualResult(false, true, ctx);
    	}
    }
    
    if (!left.asWithKeywordParameters().hasParameters() && right.asWithKeywordParameters().hasParameters()) {
    	return new LessThanOrEqualResult(true, false, ctx);
    }

    if (left.asWithKeywordParameters().hasParameters() && !right.asWithKeywordParameters().hasParameters()) {
    	return new LessThanOrEqualResult(false, false, ctx);
    }
    
    if (left.asWithKeywordParameters().hasParameters() && right.asWithKeywordParameters().hasParameters()) {
    	Map<String, IValue> paramsLeft = left.asWithKeywordParameters().getParameters();
    	Map<String, IValue> paramsRight = right.asWithKeywordParameters().getParameters();
    	if (paramsLeft.size() < paramsRight.size()) {
    		return new LessThanOrEqualResult(true, false, ctx);
    	}
    	if (paramsLeft.size() > paramsRight.size()) {
    		return new LessThanOrEqualResult(false, false, ctx);
    	}
    	if (paramsRight.keySet().containsAll(paramsLeft.keySet()) && !paramsRight.keySet().equals(paramsLeft.keySet())) {
    		return new LessThanOrEqualResult(true, false, ctx);
    	}
    	if (paramsLeft.keySet().containsAll(paramsLeft.keySet()) && !paramsRight.keySet().equals(paramsLeft.keySet())) {
    		return new LessThanOrEqualResult(false, false, ctx);
    	}
    	//assert paramsLeft.keySet().equals(paramsRight.keySet());
    	for (String k: paramsLeft.keySet()) {
    		IValue paramLeft = paramsLeft.get(k);
    		IValue paramRight = paramsRight.get(k);
    		LessThanOrEqualResult loe = makeResult(paramLeft.getType(), paramLeft, ctx).lessThanOrEqual(makeResult(paramRight.getType(), paramRight,ctx));

        	if (loe.getLess() && !loe.getEqual()) {
        		return new LessThanOrEqualResult(true, false, ctx);
        	}

        	if (!loe.getEqual()) { 
        		return new LessThanOrEqualResult(false, false, ctx);
        	}
    	}
     }
    
     return new LessThanOrEqualResult(false, true, ctx);
     //return new LessThanOrEqualResult(leftArity < rightArity, leftArity == rightArity, ctx);
	}

	@Override
	protected Result<IBool> equalToNode(NodeResult that) {
		return that.equalityBoolean(this);
	}
	
	@Override
	protected Result<IBool> nonEqualToNode(NodeResult that) {
		return that.nonEqualityBoolean(this);
	}
	
	@Override
	public <U extends IValue> Result<U> getAnnotation(String annoName, Environment env) {
		Type annoType = env.getAnnotationType(getType(), annoName);
	
		if (annoType == null) {
			throw new UndeclaredAnnotation(annoName, getType(), ctx.getCurrentAST());
		}
	
		IValue annoValue = getValue().asAnnotatable().getAnnotation(annoName);
		if (annoValue == null) {
			throw RuntimeExceptionFactory.noSuchAnnotation(annoName, ctx.getCurrentAST(), null);
		}
		// TODO: applyRules?
		return makeResult(annoType, annoValue, ctx);
	}

}
