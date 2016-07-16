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
 *   * Arnold Lankamp - Arnold.Lankamp@cwi.nl
*******************************************************************************/
package org.rascalmpl.interpreter.control_exceptions;

public class Failure extends ControlException{
	private static final long serialVersionUID = 2774285953244945424L;
	
	private final String label;
	
	public Failure() {
		super();
		
		label = null;
	}
	
	public Failure(String label) {
		super();
		
		this.label = label;
	}
	
	public boolean hasLabel() {
		return label != null;
	}
	
	public String getLabel() {
		return label;
	}
}
