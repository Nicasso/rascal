/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:

 *   * Jurgen J. Vinju - Jurgen.Vinju@cwi.nl - CWI
*******************************************************************************/
package org.rascalmpl.interpreter.result;

import java.util.Map;

import org.rascalmpl.debug.IRascalMonitor;
import org.rascalmpl.interpreter.IEvaluator;
import org.rascalmpl.interpreter.env.Environment;
import org.rascalmpl.value.IExternalValue;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.type.Type;

public interface ICallableValue extends IExternalValue {
	public int getArity();
	public boolean hasVarArgs();
	public boolean hasKeywordArguments();
	
	public Result<IValue> call(IRascalMonitor monitor, Type[] argTypes, IValue[] argValues, Map<String, IValue> keyArgValues);
	
	public Result<IValue> call(Type[] argTypes, IValue[] argValues, Map<String, IValue> keyArgValues);
	
	public abstract ICallableValue cloneInto(Environment env);
	
	public boolean isStatic();
	
	public IEvaluator<Result<IValue>> getEval();
}
