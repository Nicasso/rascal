/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
*******************************************************************************/
package org.rascalmpl.library.experiments.resource.results;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.interpreter.result.ResourceResult;
import org.rascalmpl.library.Prelude;
import org.rascalmpl.uri.file.FileURIResolver;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.type.Type;

public class FileResult extends ResourceResult {

	public FileResult(Type type, IValue value, IEvaluatorContext ctx, ISourceLocation fullURI, String displayURI) {
		super(type, value, ctx, fullURI, displayURI);
		Prelude prelude = new Prelude(ctx.getValueFactory());
		ISourceLocation uri = FileURIResolver.constructFileURI(fullURI.getPath());
		this.value = prelude.readFile(uri);
	}

}
