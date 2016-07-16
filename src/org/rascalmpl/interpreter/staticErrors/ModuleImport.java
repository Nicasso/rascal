/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:

 *   * Jurgen J. Vinju - Jurgen.Vinju@cwi.nl - CWI
 *   * Arnold Lankamp - Arnold.Lankamp@cwi.nl
*******************************************************************************/
package org.rascalmpl.interpreter.staticErrors;

import org.rascalmpl.ast.AbstractAST;
import org.rascalmpl.value.ISourceLocation;

public class ModuleImport extends StaticError {
	public ModuleImport(String name, String cause, AbstractAST ast) {
		super("Could not import module " + name + (cause != null ? (": " + cause) : ""), ast);
	}

	public ModuleImport(String name, String cause, ISourceLocation errorLocation) {
		super("Could not import module " + name + (cause != null ? (": " + cause) : ""), errorLocation);
	}

	private static final long serialVersionUID = -2382848293435609203L;

}
