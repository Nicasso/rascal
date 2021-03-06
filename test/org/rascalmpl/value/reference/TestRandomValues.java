/*******************************************************************************
* Copyright (c) 2011 Centrum Wiskunde en Informatica (CWI)
* All rights reserved. This program and the accompanying materials
* are made available under the terms of the Eclipse Public License v1.0
* which accompanies this distribution, and is available at
* http://www.eclipse.org/legal/epl-v10.html
*
* Contributors:
*    Anya Helene Bagge (anya@ii.uib.no) - initial implementation
*******************************************************************************/
package org.rascalmpl.value.reference;

import org.rascalmpl.value.BaseTestRandomValues;
import org.rascalmpl.value.impl.reference.ValueFactory;

public class TestRandomValues extends BaseTestRandomValues {
	
	@Override
	protected void setUp() throws Exception {
		super.setUp(ValueFactory.getInstance());
	}
}
