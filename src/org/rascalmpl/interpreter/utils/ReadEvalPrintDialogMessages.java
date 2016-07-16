/*******************************************************************************
 * Copyright (c) 2012-2013 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:

 *   * Jurgen J. Vinju - Jurgen.Vinju@cwi.nl - CWI
 *   * Davy Landman  - Davy.Landman@cwi.nl - CWI
*******************************************************************************/
package org.rascalmpl.interpreter.utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.regex.Matcher;

import org.rascalmpl.interpreter.StackTrace;
import org.rascalmpl.interpreter.asserts.Ambiguous;
import org.rascalmpl.interpreter.control_exceptions.InterruptException;
import org.rascalmpl.interpreter.control_exceptions.Throw;
import org.rascalmpl.interpreter.result.Result;
import org.rascalmpl.interpreter.staticErrors.StaticError;
import org.rascalmpl.interpreter.utils.LimitedResultWriter.IOLimitReachedException;
import org.rascalmpl.parser.gtd.exception.ParseError;
import org.rascalmpl.value.IConstructor;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.io.StandardTextWriter;
import org.rascalmpl.value.type.Type;
import org.rascalmpl.values.uptr.RascalValueFactory;
import org.rascalmpl.values.uptr.TreeAdapter;

public class ReadEvalPrintDialogMessages {
	public static final String PROMPT = "rascal>";
	public static final String CONTINUE_PROMPT = ">>>>>>>";
	public static final String CANCELLED = "cancelled";
	
	public static String resultMessage(Result<IValue> result) {
		String content;
		IValue value = result.getValue();
		
		if (value != null) {
			Type type = result.getType();
			
			if (type.isAbstractData() && type.isSubtypeOf(RascalValueFactory.Tree)) {
				content = type.toString() + ": `" + TreeAdapter.yield((IConstructor) value, 1000) + "`\n";
				
				StandardTextWriter stw = new StandardTextWriter(false);
				LimitedResultWriter lros = new LimitedResultWriter(1000);
				try{
					stw.write(value, lros);
				}catch(IOLimitReachedException iolrex){
					// This is fine, ignore.
				}catch(IOException ioex){
					// This can never happen.
				}
				content += "Tree: " + lros.toString();
			} else {
				content = result.toString(4096) + "\n";
			}
		} else {
			content = "ok\n";
		}
		return content;
	}

	public static String parseErrorMessage(String command, String scheme, ParseError pe) {
		StringBuilder content = new StringBuilder();
		if (pe.getLocation().getScheme().equals(scheme)) {
			String[] commandLines = command.split("\n");
			int lastLine = commandLines.length;
			int lastColumn = commandLines[lastLine - 1].length();

			if (!(pe.getEndLine() + 1 == lastLine && lastColumn <= pe.getEndColumn())) { 
				int i = 0;
				for ( ; i < pe.getEndColumn() + PROMPT.length(); i++) {
					content.append(' ');
				}
				content.append('^');
				content.append(' ');
				content.append("Parse error here");
				if (i > 80) {
					content.append("\nParse error at column ");
					content.append(pe.getEndColumn());
				}
			}
		}
		else {
			content.append('|');
			content.append(pe.getLocation().toString());
			content.append('|');
			content.append('(');
			content.append(pe.getOffset());
			content.append(',');
			content.append(pe.getLength());
			content.append(',');
			content.append('<');
			content.append(pe.getBeginLine());
			content.append(',');
			content.append(pe.getBeginColumn());
			content.append('>');
			content.append(',');
			content.append('<');
			content.append(pe.getEndLine());
			content.append(',');
			content.append(pe.getEndColumn());
			content.append('>');
			content.append(')');
			content.append(':');
			content.append(' ');
			content.append("Parse error");
			content.append('\n');
		}
		
		return content.toString();
	}

	public static String interruptedExceptionMessage(InterruptException i) {
		String content;
		content = i.getMessage();
		return content;
	}

	public static String ambiguousMessage(Ambiguous e) {
		StringBuilder content = new StringBuilder();
		content.append(e.getLocation());
		content.append(':');
		content.append(' ');
		content.append(e.getMessage());
		content.append('\t');
		IConstructor tree = e.getTree();
		if (tree != null) {
			content.append("diagnose using: ");
			content.append(getValueString(e.getTree()));
		}
		content.append('\n');
		return content.toString();
	}
	
	private static String getValueString(IConstructor tree) {
		String val = tree.toString();
		val = val.replaceAll("\\\\", Matcher.quoteReplacement("\\\\"));
		val = val.replaceAll("\"", Matcher.quoteReplacement("\\\""));
		val = val.replaceAll("<", Matcher.quoteReplacement("\\<"));
		val = val.replaceAll(">", Matcher.quoteReplacement("\\>"));
		return "\"" + val + "\"";
	}

	public static String throwableMessage(Throwable e, StackTrace rascalTrace) {
		StringWriter w = new StringWriter();
		PrintWriter p = new PrintWriter(w);
		p.append(e.toString());
		p.append("(internal error)");
		p.append(rascalTrace.toLinkedString());
		e.printStackTrace(p);
		p.flush();
		w.flush();
		return w.toString();
	}
	
	public static String parseOrStaticOrThrowMessage(RuntimeException e) {
		if (e instanceof ParseError)
			return parseErrorMessage("unkown", "unkown", (ParseError)e);
		if (e instanceof StaticError) 
			return staticErrorMessage((StaticError)e);
		if (e instanceof Throw)
			return throwMessage((Throw)e);
		return "Not a rascal exception: " + e.toString();
	}

	public static String throwMessage(Throw e) {
		LimitedResultWriter lros = new LimitedResultWriter(1000);
		StandardTextWriter stw = new StandardTextWriter(false);
		try {
			stw.write(e.getException(), lros);
		}
		catch(IOLimitReachedException iolrex){
			// This is fine, ignore.
		}
		catch(IOException ioex){
			// This can never happen.
		}
		
		String content = e.getLocation().toString() 
				+ ": " 
				+ lros.getBuffer().toString()
				+ "\n";
		
		StackTrace trace = e.getTrace();
		if (trace != null) {
			content += trace.toLinkedString() + '\n';
		}
		return content;
	}

	public static String staticErrorMessage(StaticError e) {
		return e.getLocation() + ": " + e.getMessage() + "\n";
	}
}
