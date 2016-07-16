/*******************************************************************************
 * Copyright (c) 2009-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
*******************************************************************************/
package org.rascalmpl.library.analysis.statistics;

import org.apache.commons.math.MathException;
import org.apache.commons.math.stat.regression.SimpleRegression;
import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;
import org.rascalmpl.value.IList;
import org.rascalmpl.value.INumber;
import org.rascalmpl.value.ITuple;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;

public class SimpleRegressions {
	
	private final IValueFactory values;
	
	public SimpleRegressions(IValueFactory values){
		super();
		this.values = values;
	}
	
	SimpleRegression make(IList dataValues){
		if(dataValues.length() <= 2)
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "SimpleRegression data should have more than 2 elements");
		SimpleRegression simple = new SimpleRegression();
		for(IValue v : dataValues){
			ITuple t = (ITuple) v;
			INumber x = (INumber) t.get(0);
			INumber y = (INumber) t.get(1);
			simple.addData(x.toReal(values.getPrecision()).doubleValue(), y.toReal(values.getPrecision()).doubleValue());
		}
		return simple;
	}

	
	public IValue intercept(IList dataValues) {
		try {
			return values.real(make(dataValues).getIntercept());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue interceptStdErr(IList dataValues) {
		try {
			return values.real(make(dataValues).getInterceptStdErr());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue meanSquareError(IList dataValues) {
		try {
			return values.real(make(dataValues).getMeanSquareError());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}

	public IValue R(IList dataValues) {
		try {
			return values.real(make(dataValues).getR());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue RSquare(IList dataValues) {
		try {
			return values.real(make(dataValues).getRSquare());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue regressionSumSquares(IList dataValues) {
		try {
			return values.real(make(dataValues).getRegressionSumSquares());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue significance(IList dataValues) {
		try {
			return values.real(make(dataValues).getSignificance());
		} catch (MathException e) {
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, e.getMessage());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue slope(IList dataValues) {
		try {
			return values.real(make(dataValues).getSlope());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue slopeConfidenceInterval(IList dataValues) {
		try {
			return values.real(make(dataValues).getSlopeConfidenceInterval());
		} catch (MathException e) {
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, e.getMessage());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue slopeConfidenceInterval(IList dataValues, INumber alpha) {
		try {
			return values.real(make(dataValues).getSlopeConfidenceInterval(alpha.toReal(values.getPrecision()).doubleValue()));
		} catch (MathException e) {
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, e.getMessage());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	
	public IValue slopeStdErr(IList dataValues) {
		try {
			return values.real(make(dataValues).getSlopeStdErr());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue sumOfCrossProducts(IList dataValues) {
		try {
			return values.real(make(dataValues).getSumOfCrossProducts());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue sumSquaredErrors(IList dataValues) {
		try {
			return values.real(make(dataValues).getSumSquaredErrors());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue totalSumSquares(IList dataValues) {
		try {
			return values.real(make(dataValues).getTotalSumSquares());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue XSumSquares(IList dataValues) {
		try {
			return values.real(make(dataValues).getXSumSquares());
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
	public IValue predict(IList dataValues, INumber x) {
		try {
			return values.real(make(dataValues).predict(x.toReal(values.getPrecision()).doubleValue()));
		} catch(NumberFormatException e){
			throw RuntimeExceptionFactory.illegalArgument(dataValues, null, null, "Not enough variation in x values");
		}
	}
	
}
