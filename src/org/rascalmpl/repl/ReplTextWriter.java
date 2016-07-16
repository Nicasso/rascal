package org.rascalmpl.repl;

import java.io.IOException;
import java.io.StringWriter;

import org.fusesource.jansi.Ansi;
import org.fusesource.jansi.Ansi.Attribute;
import org.fusesource.jansi.Ansi.Color;
import org.rascalmpl.value.ISourceLocation;
import org.rascalmpl.value.IValue;
import org.rascalmpl.value.io.StandardTextWriter;

public class ReplTextWriter extends StandardTextWriter {

    private static final String RESET = Ansi.ansi().reset().toString();
    private static final String SOURCE_LOCATION_PREFIX = Ansi.ansi().reset().fg(Color.BLUE).a(Attribute.UNDERLINE).toString();
    public ReplTextWriter() {
        super(true);
    }

    public ReplTextWriter(boolean indent) {
        super(indent);
    }

    public static String valueToString(IValue value) {
        try(StringWriter stream = new StringWriter()) {
            new ReplTextWriter().write(value, stream);
            return stream.toString();
        } catch (IOException ioex) {
            throw new RuntimeException("Should have never happened.", ioex);
        }
    }

    @Override
    public void write(IValue value, final java.io.Writer stream) throws IOException {
        value.accept(new Writer(stream, this.indent, this.tabSize) {
            @Override
            public IValue visitSourceLocation(ISourceLocation o) throws IOException {
                stream.write(SOURCE_LOCATION_PREFIX);
                IValue result = super.visitSourceLocation(o);
                stream.write(RESET);
                return result;
            }
        });
    }


}
