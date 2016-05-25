package org.rascalmpl.library.lang.css.m3.internal;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

import org.rascalmpl.interpreter.IEvaluatorContext;
import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;
import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.RascalRuntimeException;
import org.rascalmpl.parser.gtd.io.InputConverter;
import org.rascalmpl.unicode.UnicodeDetector;
import org.rascalmpl.uri.URIResolverRegistry;
import org.rascalmpl.value.IList;
import org.rascalmpl.value.ISet;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.IValueFactory;

public class FileHandler {

	protected final IValueFactory valueFactory;
	protected IEvaluatorContext eval;

	public FileHandler(IValueFactory vf) {
		this.valueFactory = vf;
	}

	protected char[] getFileContents(ISourceLocation loc) throws IOException {
		try (Reader textStream = URIResolverRegistry.getInstance().getCharacterReader(loc)) {
			return InputConverter.toChar(textStream);
		}
	}
	
	protected String[] translatePaths(IList paths) {
		String[] result = new String[paths.length()];
		int i = 0;
		for (IValue p : paths) {
			ISourceLocation loc = safeResolve((ISourceLocation) p);
			if (!loc.getScheme().equals("file")) {
				throw RascalRuntimeException
						.io(valueFactory.string("all path entries must have (or resolve to) the file:/// scheme: " + loc), null);
			}
			result[i++] = new File(loc.getPath()).getAbsolutePath();
		}
		return result;
	}

	private String guessEncoding(ISourceLocation loc) {
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

	protected String[] convertPaths(ISet files) {
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

	protected String convertPath(IValue file) {
		ISourceLocation loc = (ISourceLocation) file;
		if (!URIResolverRegistry.getInstance().isFile(loc)) {
			throw RuntimeExceptionFactory.io(valueFactory.string("" + loc + " is not a file"), null, null);
		}
		if (!URIResolverRegistry.getInstance().exists(loc)) {
			throw RuntimeExceptionFactory.io(valueFactory.string("" + loc + " doesn't exist"), null, null);
		}

		return new File(safeResolve(loc).getPath()).getAbsolutePath();
	}

	protected ISourceLocation safeResolve(ISourceLocation loc) {
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
