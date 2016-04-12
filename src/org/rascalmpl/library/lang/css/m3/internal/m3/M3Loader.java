package org.rascalmpl.library.lang.css.m3.internal.m3;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.library.lang.css.m3.internal.FileHandler;
import org.rascalmpl.library.lang.css.m3.internal.SourceConverter;
import org.rascalmpl.library.lang.css.m3.internal.ast.ASTConverter;
import org.rascalmpl.value.ISet;
import org.rascalmpl.value.ISetWriter;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.IString;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;
import org.rascalmpl.value.type.TypeStore;

import cz.vutbr.web.css.CSSException;
import cz.vutbr.web.css.CSSFactory;
import cz.vutbr.web.css.StyleSheet;

public class M3Loader extends FileHandler {

	public M3Loader(IValueFactory vf) {
		super(vf);
	}
	
	public IValue createM3sFromFiles(ISet files, IEvaluatorContext eval) {
		this.eval = eval;

		eval.getStdOut().println("createM3sFromFiles");
		eval.getStdOut().flush();

		ISetWriter result = valueFactory.setWriter();

		boolean fastPath = true;
		for (IValue f : files) {
			fastPath &= safeResolve((ISourceLocation) f).getScheme().equals("file");
		}
		
		if (!fastPath) {
			for (IValue f : files) {
				StyleSheet style = null;

				ISourceLocation loc = (ISourceLocation) f;

				boolean go = true;

				try {
					style = CSSFactory.parse(getFileContents(loc).toString(), "UTF-8");
				} catch (CSSException | IOException e) {
					eval.getStdErr().println(e.getMessage());
					eval.getStdErr().flush();
					go = false;
				}

				if (go) {
					TypeStore store = new TypeStore();
					store.extendStore(eval.getHeap().getModule("lang::css::m3::AST").getStore());
					store.extendStore(eval.getHeap().getModule("lang::css::m3::Core").getStore());
					// eval.getStdOut().println(store.getConstructors().toString());
					// eval.getStdOut().flush();
					eval.getStdOut().println("2");
					
					//ASTConverter ast = new ASTConverter(style, store, eval);
					
					result.insert(convertToM3(store, new HashMap<>(), style));
				}
			}
		} else {
			String[] converted = convertPaths(files);

			TypeStore store = new TypeStore();
			store.extendStore(eval.getHeap().getModule("lang::css::m3::AST").getStore());
			// eval.getStdOut().println(store.getConstructors().toString());
			// eval.getStdOut().flush();

			for (String f : converted) {
				boolean go = true;
				StyleSheet style = null;
				try {
					style = CSSFactory.parse(f, "utf-8");
				} catch (CSSException | IOException e) {
					eval.getStdErr().println(e.getMessage());
					eval.getStdErr().flush();
					go = false;
				}
				if (go) {
					result.insert(convertToM3(store, new HashMap<>(), style));
				}
			}

		}

		// Return AST after it is converted to IValues.
		return result.done();
	}
	
	public IValue createM3FromString(IString contents, IEvaluatorContext eval) {
		this.eval = eval;
		
		eval.getStdOut().println("createM3FromString");
		eval.getStdOut().flush();

		StyleSheet style = null;
		boolean go = true;

		try {
			// @TODO This null needs to be replaced lated with a optional URL,
			// for @import and url's.
			style = CSSFactory.parseString(contents.getValue(), null);
		} catch (CSSException | IOException e) {
			eval.getStdErr().println("PARSING THE CSS HAS FAILED!");
			eval.getStdErr().println(e.getMessage());
			eval.getStdErr().flush();
			go = false;
		}

		if (go) {
			TypeStore store = new TypeStore();
			store.extendStore(eval.getHeap().getModule("lang::css::m3::AST").getStore());
			store.extendStore(eval.getHeap().getModule("lang::css::m3::Core").getStore());
			// eval.getStdOut().println(store.getConstructors().toString());
			// eval.getStdOut().flush();
			eval.getStdOut().println("2");
			
			//ASTConverter ast = new ASTConverter(style, store, eval);
			
			return convertToM3(store, new HashMap<>(), style);
		}
		// Return M3 after it is converted to IValues.
		return null;
	}
	
	protected IValue convertToM3(TypeStore store, Map<String, ISourceLocation> cache, StyleSheet ast) {
		
		SourceConverter converter = new SourceConverter(store, cache, eval);
        converter.convert(ast);
        
        return converter.getModel(true, null);
    }
	
}
