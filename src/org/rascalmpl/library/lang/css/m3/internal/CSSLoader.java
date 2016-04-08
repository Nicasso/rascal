package org.rascalmpl.library.lang.css.m3.internal;

import java.io.IOException;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.value.ISet;
import org.rascalmpl.value.IString;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;
import org.rascalmpl.value.type.TypeStore;

import cz.vutbr.web.css.CSSException;
import cz.vutbr.web.css.CSSFactory;
import cz.vutbr.web.css.StyleSheet;

public class CSSLoader {
	
	protected final IValueFactory valueFactory;

    public CSSLoader(IValueFactory vf) {
        this.valueFactory = vf;
    }

	public IValue createAstsFromFiles(ISet files, IEvaluatorContext eval) {
		
		eval.getStdOut().println("createAstsFromFiles");
		eval.getStdOut().flush();
		
		for (IValue f : files) {
			try {
				StyleSheet style = CSSFactory.parse(f.getType().getValueLabel(), "UTF-8");
				
				TypeStore store = new TypeStore();
		        store.extendStore(eval.getHeap().getModule("lang::css::m3::AST").getStore());
				
				ASTConverter ast = new ASTConverter(style, store, eval);
			} catch (CSSException | IOException e) {
				eval.getStdErr().println(e.getMessage());
				eval.getStdErr().flush();
			}
        }
		// Return AST after it is converted to IValues.
		return null;
	}

	public IValue createAstFromString(IString contents, IEvaluatorContext eval) {		

		eval.getStdOut().println("createAstFromString");
		eval.getStdOut().flush();
		
		try {
			// @TODO This null needs to be replaced lated with a optional URL, for @import and url's. 
			StyleSheet style = CSSFactory.parseString(contents.getValue(), null);
			
			TypeStore store = new TypeStore();
	        store.extendStore(eval.getHeap().getModule("lang::css::m3::AST").getStore());
	        
			ASTConverter ast = new ASTConverter(style, store, eval);
		} catch (CSSException | IOException e) {
			eval.getStdErr().println(e.getMessage());
			eval.getStdErr().flush();
		}
		// Return AST after it is converted to IValues.
		return null;
	}
}