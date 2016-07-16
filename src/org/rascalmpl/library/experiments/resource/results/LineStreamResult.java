/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
*******************************************************************************/
package org.rascalmpl.library.experiments.resource.results;

import java.net.URI;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.interpreter.result.ResourceResult;
import org.rascalmpl.library.experiments.resource.results.buffers.LazyList;
import org.rascalmpl.library.experiments.resource.results.buffers.LineStreamFiller;
import org.rascalmpl.uri.URIUtil;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.type.Type;
import org.rascalmpl.values.ValueFactoryFactory;

public class LineStreamResult extends ResourceResult {

	public LineStreamResult(Type type, IValue value, IEvaluatorContext ctx, ISourceLocation fullURI, String displayURI) {
		super(type, value, ctx, fullURI, displayURI);
		String str = fullURI.getPath();
		String newHost = str.substring(1,str.indexOf("/",1));
		String newPath = str.substring(str.indexOf("/",1)+1);
		URI uri = URIUtil.assumeCorrect(newHost, "", newPath);
		this.value = new LazyList(25, new LineStreamFiller(ValueFactoryFactory.getValueFactory().sourceLocation(uri), ctx), type.getElementType());
	}

}
