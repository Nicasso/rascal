/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:

 *   * Jurgen J. Vinju - Jurgen.Vinju@cwi.nl - CWI
 *   * Paul Klint - Paul.Klint@cwi.nl - CWI
*******************************************************************************/
package org.rascalmpl.interpreter.staticErrors;

import org.rascalmpl.ast.AbstractAST;

public class UninitializedVariable extends StaticError {
	private static final long serialVersionUID = -7290225483329876543L;
    
	public UninitializedVariable(String name, AbstractAST ast) {
	  super("Uninitialized variable: " + name, ast);
	}
	
	public UninitializedVariable(AbstractAST ast) {
    super("Uninitialized variable", ast);
  }
}
