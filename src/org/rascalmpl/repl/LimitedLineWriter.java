package org.rascalmpl.repl;

import java.io.IOException;
import java.io.Writer;


public class LimitedLineWriter extends NonClosingFilterWriter {

  private final int limit;
  private int written;

  protected LimitedLineWriter(Writer out, int limit) {
    super(out);
    this.limit = limit;
    written = 0;
  }
  @Override
  public void write(int c) throws IOException {
    if (written == limit) {
      return;
    }
    out.write(c);
    if (c == '\n' || c == '\r') {
      written++;
      if (written == limit) {
        out.write("...");
      }
    }
  }
  @Override
  public void write(char[] cbuf, int off, int len) throws IOException {
    if (written == limit) {
      return;
    }
    len = calculateNewLength(cbuf, off, len);
    out.write(cbuf, off, len);
    if (written == limit) {
      out.write("...");
    }
  }

  private int calculateNewLength(char[] cbuf, int off, int len) {
    for (int i = off; i < off + len; i++) {
      if (cbuf[i] == '\n' || cbuf[i]  == '\r') {
        written++;
        if (written == limit) {
          // we have to change the length to just after the last newline
          return Math.min((i + 1) - off, len);
        }
      }
    }
    return len;
  }

  private int calculateNewLength(String str, int off, int len) {
    for (int i = off; i < off + len; i++) {
      if (str.charAt(i) == '\n' || str.charAt(i)  == '\r') {
        written++;
        if (written == limit) {
          // we have to change the length to just after the last newline
          return Math.min((i + 1) - off, len);
        }
      }
    }
    return len;
  }

  @Override
  public void write(String str, int off, int len) throws IOException {
    if (written == limit) {
      return;
    }
    len = calculateNewLength(str, off, len);
    out.write(str, off, len);
    if (written == limit) {
      out.write("...");
    }
  }

}
