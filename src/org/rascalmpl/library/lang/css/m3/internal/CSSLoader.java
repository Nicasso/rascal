package org.rascalmpl.library.lang.css.m3.internal;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.jdt.core.dom.ASTParser;
import org.eclipse.jdt.core.dom.CompilationUnit;
import org.eclipse.jdt.core.dom.FileASTRequestor;
import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;
import org.rascalmpl.parser.gtd.io.InputConverter;
import org.rascalmpl.unicode.UnicodeDetector;
import org.rascalmpl.uri.URIResolverRegistry;
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

public class CSSLoader {

	protected final IValueFactory valueFactory;

	public CSSLoader(IValueFactory vf) {
		this.valueFactory = vf;
	}

	protected char[] getFileContents(ISourceLocation loc) throws IOException {
		try (Reader textStream = URIResolverRegistry.getInstance().getCharacterReader(loc)) {
			return InputConverter.toChar(textStream);
		}
	}

	protected String guessEncoding(ISourceLocation loc) {
		try {
			Charset result = URIResolverRegistry.getInstance().getCharset(loc);
			if (result != null) {
				return result.name();
			}
			try (InputStream file = URIResolverRegistry.getInstance().getInputStream(loc)) {
				return UnicodeDetector.estimateCharset(file).name();
			}
		} catch (Throwable x) {
			return null;
		}
	}

	private String[] convertPaths(ISet files) {
		Map<String, ISourceLocation> reversePathLookup = new HashMap<>();
		String[] absolutePaths = new String[files.size()];
		String[] encodings = new String[absolutePaths.length];
		int i = 0;
		for (IValue p : files) {
			ISourceLocation loc = (ISourceLocation) p;
			if (!URIResolverRegistry.getInstance().isFile(loc)) {
				throw RuntimeExceptionFactory.io(valueFactory.string("" + loc + " is not a file"), null, null);
			}
			if (!URIResolverRegistry.getInstance().exists(loc)) {
				throw RuntimeExceptionFactory.io(valueFactory.string("" + loc + " doesn't exist"), null, null);
			}

			absolutePaths[i] = new File(safeResolve(loc).getPath()).getAbsolutePath();
			reversePathLookup.put(absolutePaths[i], loc);
			encodings[i] = guessEncoding(loc);
			i++;
		}
		return absolutePaths;
	}

	public IValue createAstsFromFiles(ISet files, IEvaluatorContext eval) {

		eval.getStdOut().println("createAstsFromFiles");
		eval.getStdOut().flush();

		ISetWriter result = valueFactory.setWriter();

		boolean fastPath = true;
		for (IValue f : files) {
			fastPath &= safeResolve((ISourceLocation) f).getScheme().equals("file");
		}
		eval.getStdOut().println("fastPath: "+fastPath);
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
					// eval.getStdOut().println(store.getConstructors().toString());
					// eval.getStdOut().flush();
					ASTConverter ast = new ASTConverter(style, store, eval);
					result.insert(ast.getAST());
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
					ASTConverter ast = new ASTConverter(style, store, eval);
					result.insert(ast.getAST());
				}
			}

		}

		// Return AST after it is converted to IValues.
		return result.done();
	}

	public IValue createAstFromString(IString contents, IEvaluatorContext eval) {

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
			// eval.getStdOut().println(store.getConstructors().toString());
			// eval.getStdOut().flush();
			ASTConverter ast = new ASTConverter(style, store, eval);
			return ast.getAST();
		}
		// Return AST after it is converted to IValues.
		return null;
	}

	private ISourceLocation safeResolve(ISourceLocation loc) {
		try {
			ISourceLocation result = URIResolverRegistry.getInstance().logicalToPhysical(loc);
			if (result != null) {
				return result;
			}
			return loc;
		} catch (IOException e) {
			return loc;
		}
	}
}