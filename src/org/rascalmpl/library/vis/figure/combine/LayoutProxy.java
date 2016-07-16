/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
*******************************************************************************/
package org.rascalmpl.library.vis.figure.combine;

import java.util.List;

import org.rascalmpl.library.vis.figure.Figure;
import org.rascalmpl.library.vis.graphics.GraphicsContext;
import org.rascalmpl.library.vis.properties.PropertyManager;
import org.rascalmpl.library.vis.swt.applet.IHasSWTElement;
import org.rascalmpl.library.vis.util.vector.Rectangle;

public abstract class LayoutProxy extends WithInnerFig {

	// Figure which is merely a wrapper for the inner figure from a layout perspective
	
	public LayoutProxy(Figure inner, PropertyManager properties) {
		super(inner, properties);
		if(inner!=null){
			properties.stealExternalPropertiesFrom(inner.prop);
		}
	}

	@Override
	public void computeMinSize() {
		minSize.set(innerFig.minSize);
		resizable.set(innerFig.resizable);
	}

	@Override
	public void resizeElement(Rectangle view) {
		innerFig.size.set(size);
		innerFig.localLocation.set(0,0);
	}
	

	protected void setInnerFig(Figure inner){
		if(inner!=null){
			children = new Figure[1];
			children[0] = inner;
		} else {
			children = EMPTY_ARRAY;
		}
		innerFig = inner;
	}
	
	@Override
	public void connectArrowFrom(double X, double Y, double fromX, double fromY,
			Figure toArrow, GraphicsContext gc, List<IHasSWTElement> visibleSWTElements ) {
		if(children.length > 0){
			children[0].connectArrowFrom(X, Y, fromX, fromY, toArrow, gc, visibleSWTElements);
		}
	}
	
}
