/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
*******************************************************************************/
package org.rascalmpl.library.vis.figure.compose;

import java.util.List;

import org.rascalmpl.library.vis.figure.Figure;
import org.rascalmpl.library.vis.graphics.GraphicsContext;
import org.rascalmpl.library.vis.properties.PropertyManager;
import org.rascalmpl.library.vis.swt.applet.IHasSWTElement;
import org.rascalmpl.library.vis.util.vector.BoundingBox;
import org.rascalmpl.library.vis.util.vector.Coordinate;
import org.rascalmpl.library.vis.util.vector.Dimension;

public abstract class WidthDependsOnHeight extends Compose{

	Dimension major, minor;
	BoundingBox realSize;
	
	public static final double MINOR_MINSIZE = 30;
	
	protected WidthDependsOnHeight(Dimension major, Figure[] figures, PropertyManager properties) {
		super(figures, properties);
		this.major = major;
		minor = major.other();
		realSize = new BoundingBox();
	}
	
	@Override
	public boolean widthDependsOnHeight(){
		return true;
	}
	
	public Dimension getMajorDimension(){
		return major;
	}

	@Override
	public boolean mouseInside(Coordinate c) {
		return c.getX() >= globalLocation.getX() && c.getX() <= globalLocation.getX() + realSize.getX()
				&& c.getY() >= globalLocation.getY() && c.getY() <= globalLocation.getY()+ realSize.getY();
	}
	
	@Override
	public void computeMinSize() {
		double minWidth = 0;
		for(Figure fig : children){
			minWidth = Math.max(minWidth,fig.minSize.get(major) );
		}
		minSize.set(major, Math.ceil(minWidth) + 1);
		minSize.set(minor, MINOR_MINSIZE);
	}



	public void drawElement(GraphicsContext gc, List<IHasSWTElement> visibleSWTElements){
		//gc.rect(globalLocation.getX()-3, globalLocation.getY()-3, size.getX()+3, size.getY()+3);
	}
	
	
}
