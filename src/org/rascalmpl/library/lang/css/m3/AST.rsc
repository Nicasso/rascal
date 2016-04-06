module lang::css::m3::AST

extend analysis::m3::AST;

import util::FileSystem;
import lang::css::m3::TypeSymbol;
import IO;
import Set;
import String;
import List;

data Statement
    = ruleSet(list[Expression] selectors, list[Declaration] declarations)
    | ruleMedia(Expression mediaQueries, Statement \value)
    | ruleFontFace(Statement \value)
    | ruleImport(Type uri)
    | ruleMargin(Expression atRule, Statement \value)
    | rulePage(Expression atRule, Statement \value)
    | ruleViewport(Expression atRule, Statement \value)
    ;

data Declaration
    = declaration(Expression property, Expression \value, Modifier modifier)
    ;

data Expression 
    = selector(Type \type, Expression expression)
    | property(Type \type, list[Expression] dimensions)
    | \value(Type \type, list[Expression] dimensions)
    | string(str \value)
    ;

data Type 
    = class()
    | id()
    | domElement()
    | property()
    | angle()
    | color()
    | expression()
    | frequency()
    | function()
    | ident()
    | integer()
    | length()
    | percent()
    | \list()
    | number()
    | numeric()
    | pair()
    | percent()
    | resolution()
    | string()
    | time()
    | uri()
    ;

data Modifier
    = important()
    ;
    
public Declaration createAstFromFile(loc file) {
    result = createAstsFromFiles({file});
    if ({oneResult} := result) {
        return oneResult;
    }
    throw "Unexpected number of ASTs returned from <file>";
}

@javaClass{org.rascalmpl.library.lang.css.m3.internal.CSSLoader}
@reflect{Need access to stderr/stdout}
public java set[Statement] createAstsFromFiles(set[loc] file);

@javaClass{org.rascalmpl.library.lang.css.m3.internal.CSSLoader}
@reflect{Need access to stderr/stdout}
public java Statement createAstFromString(str source);

public set[Declaration] createAstsFromDirectory(loc project) {
    if (!(isDirectory(project))) {
      throw "<project> is not a valid directory";
    }
    
    allCSSFiles = [ j | j <- find(project, "css"), isFile(j) ];
    return createAstsFromFiles(allCSSFiles);
}