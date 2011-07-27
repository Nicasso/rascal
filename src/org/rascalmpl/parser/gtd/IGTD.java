/*******************************************************************************
 * Copyright (c) 2009-2011 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:

 *   * Arnold Lankamp - Arnold.Lankamp@cwi.nl
*******************************************************************************/
package org.rascalmpl.parser.gtd;

import java.net.URI;

import org.eclipse.imp.pdb.facts.IConstructor;
import org.rascalmpl.parser.gtd.result.action.IActionExecutor;
import org.rascalmpl.parser.gtd.result.out.INodeConverter;

public interface IGTD{
	IConstructor parse(String nonterminal, URI inputURI, char[] input, IActionExecutor actionExecutor, INodeConverter converter);
	
	IConstructor parse(String nonterminal, URI inputURI, char[] input, INodeConverter converter);
	
	IConstructor buildErrorTree(INodeConverter converter, IActionExecutor actionExecutor);
}
