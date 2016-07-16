/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
*******************************************************************************/
package org.rascalmpl.library.vis.util.vector;

public class TwoDimensional<T> {
	
	T x,y;
	
	public TwoDimensional(T x, T y){
		this.x = x;
		this.y = y;
	}
	
	public void setX(T d){
		x = d;
	}
	public void setY(T d){
		y = d;
	}
	public  T getX(){
		return x;
	}
	public  T getY(){
		return y;
	}
	
	public void set(Dimension d, T val){
		switch(d){
		case X: setX(val); break;
		case Y: setY(val); break;
		}
	}
	
	public void set(TwoDimensional<T> r){
		this.x = r.x;
		this.y = r.y;
	}
	
	public void set(T x, T y){
		this.x = x;
		this.y = y;
	}
	
	public T get(Dimension d){
		switch(d){
		case X: return getX();
		case Y: return getY();
		}
		return null;
	}
	
}
