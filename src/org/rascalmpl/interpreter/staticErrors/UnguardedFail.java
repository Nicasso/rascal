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
import org.rascalmpl.interpreter.control_exceptions.Failure;

public class UnguardedFail extends StaticError {
	private static final long serialVersionUID = -3024435867811407010L;

	public UnguardedFail(AbstractAST ast, Failure e) {
		super(e.hasLabel() ? "Use of fail with label " + e.getLabel() + " outside a conditional context labeled " + e.getLabel()
				: "Use of fail outside a conditional context", ast);
	}
}
