package org.rascalmpl.library.lang.css.m3.internal.ast;

import java.io.IOException;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.library.lang.css.m3.internal.FileHandler;
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

public class ASTLoader extends FileHandler {

	public ASTLoader(IValueFactory vf) {
		super(vf);
	}

	public IValue createAstsFromFiles(ISet files, IEvaluatorContext eval) {
		this.eval = eval;

		eval.getStdOut().println("createAstsFromFiles");
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

					ASTConverter ast = new ASTConverter(style, store, eval);
					result.insert(ast.getAST());
				}
			}
		} else {
			String[] converted = convertPaths(files);

			TypeStore store = new TypeStore();
			store.extendStore(eval.getHeap().getModule("lang::css::m3::AST").getStore());

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
					ASTConverter ast = new ASTConverter(style, store, eval);
					result.insert(ast.getAST());
				}
			}

		}
		return result.done();
	}

	public IValue createAstFromString(IString contents, ISourceLocation loc, IEvaluatorContext eval) {
		this.eval = eval;
		
		eval.getStdOut().println("createAstFromString");
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

			ASTConverter ast = new ASTConverter(style, store, eval);
			return ast.getAST();
		}
		return null;
	}

	
}