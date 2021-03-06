package org.rascalmpl.repl;

import java.io.IOException;
import java.io.Writer;

import org.rascalmpl.interpreter.utils.LimitedResultWriter.IOLimitReachedException;

public class LimitedWriter extends NonClosingFilterWriter {

    private final long limit;
    private long written;

    public LimitedWriter(Writer out, long limit) {
        super(out);
        this.limit = limit;
        this.written = 0;
    }

    @Override
    public void write(int c) throws IOException {
        if (written < limit) {
            out.write(c);
            written ++;
            if (written == limit) {
                out.write("...");
                out.flush();
            }
        }
        else {
            throw new IOLimitReachedException();
        }
    }

    @Override
    public void write(char[] cbuf, int off, int len) throws IOException {
        if (written == limit) {
            throw new IOLimitReachedException();
        }
        if (written + len >= limit) {
            len = (int)(limit - written);
        }
        out.write(cbuf, off, len);
        written += len;
        if (written == limit) {
            out.write("...");
            out.flush();
        }
    }

    @Override
    public void write(String str, int off, int len) throws IOException {
        if (written == limit) {
            throw new IOLimitReachedException();
        }
        if (written + len >= limit) {
            len = (int)(limit - written);
        }
        out.write(str, off, len);
        written += len;
        if (written == limit) {
            out.write("...");
            out.flush();
        }
    }
}
