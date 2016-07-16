/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
*******************************************************************************/
package org.rascalmpl.library.analysis.statistics;

import org.apache.commons.math.MathException;
import org.apache.commons.math.linear.RealMatrix;
import org.apache.commons.math.stat.correlation.Covariance;
import org.rascalmpl.value.IList;
import org.rascalmpl.value.IListWriter;
import org.rascalmpl.value.INumber;
import org.rascalmpl.value.ITuple;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;
import org.rascalmpl.value.type.Type;
import org.rascalmpl.value.type.TypeFactory;

public class Correlations {
	private final IValueFactory values;
	private TypeFactory types;
	
	public Correlations(IValueFactory values){
		super();
		this.types = TypeFactory.getInstance();
		this.values = values;
	}
	
	double [] xvalues;
	double [] yvalues;
	double [][] xyvalues;
	
	void make(IList dataValues){
		int n = dataValues.length();
		xvalues = new double[n];
		yvalues = new double[n];
		xyvalues = new double[n][n];
		int i = 0;
		for(IValue v : dataValues){
			ITuple t = (ITuple) v;
			INumber x = (INumber) t.get(0);
			INumber y = (INumber) t.get(1);
			xvalues[i] = xyvalues[i][0] = x.toReal(values.getPrecision()).doubleValue();
			yvalues[i] = xyvalues[i][0] = y.toReal(values.getPrecision()).doubleValue();
			i++;
		}
	}

	public IValue PearsonsCorrelation(IList dataValues){
		make(dataValues);
		return values.real(new org.apache.commons.math.stat.correlation.PearsonsCorrelation().correlation(xvalues, yvalues));
	}
	
	private IList RealMatrix2List(RealMatrix m){
		Type listType = types.listType(types.realType());
		IListWriter w = values.listWriter(listType.getElementType());
		int n = m.getColumnDimension();
		for(int i = 0; i < n; i++){
			w.append(values.real(m.getEntry(i,0)));
		}
		return w.done();
	}
	
	public IValue PearsonsCorrelationStandardErrors(IList dataValues){
		make(dataValues);
		RealMatrix errors = new org.apache.commons.math.stat.correlation.PearsonsCorrelation(xyvalues).getCorrelationStandardErrors();
		return RealMatrix2List(errors);
	}
	
	public IValue PearsonsCorrelationPValues(IList dataValues){
		make(dataValues);
		RealMatrix errors;
		try {
			errors = new org.apache.commons.math.stat.correlation.PearsonsCorrelation(xyvalues).getCorrelationPValues();
			return RealMatrix2List(errors);
		} catch (MathException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public IValue SpearmansCorrelation(IList dataValues){
		make(dataValues);
		return values.real(new org.apache.commons.math.stat.correlation.SpearmansCorrelation().correlation(xvalues, yvalues));
	}
	
	public IValue covariance(IList dataValues){
		make(dataValues);
		return values.real(new Covariance().covariance(xvalues, yvalues, false));
	}
}
