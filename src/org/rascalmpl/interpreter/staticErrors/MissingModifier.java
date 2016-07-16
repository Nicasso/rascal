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
package org.rascalmpl.interpreter.staticErrors;

import org.rascalmpl.ast.AbstractAST;

public class MissingModifier extends StaticError {
	private static final long serialVersionUID = 8951799317606455150L;
    
	public MissingModifier(String name, AbstractAST onWhat) {
		super("Missing modifier: " + name, onWhat);
	}
}
