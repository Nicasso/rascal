module lang::css::m3::AST

extend analysis::m3::AST;

import util::FileSystem;
import lang::css::m3::TypeSymbol;
import IO;
import Set;
import String;
import List;

data Statement
	// Rulesets
    = ruleSets(list[Statement] rules) // #lol { color: red; } #lal { color: blue; }
    | ruleSet(Expression selector, list[Declaration] declarations) // #lol { color: red; }
    // At rules
    | ruleMedia(Expression mediaQueries, Statement \value) // @media only screen and (max-width : 480px) {
    | ruleFontFace(Statement \value) // @font-face {
    | ruleImport(Type uri) // @import url("style2.css");
    | ruleMargin(Expression atRule, Statement \value) // (@TODO, when is this used?!)
    | rulePage(Expression atRule, Statement \value) // @page :left {
    | ruleViewport(Statement \value) // @viewport {
    ;

data Declaration
    = declaration(Expression property, Expression \value) // color: red;, background: url('logo.png') no-repeat;
    ;

data Expression 
    = selector(list[Type] selectors) // See Type Selector
    | property(str property) // border, color, width, font etc.
    | \value(list[Type] \values) // See type Values
    ;

data Type 
	// Selector
    = class(str name) // .lol
    | id(str name) // #lol
    | domElement(str name) // div
    | attributeSelectors(Type attribute, Type \value) // div[class*="post"]
    // Values
    | angle(int \value) // 10deg, 10grad, 1rad, 0.25turn
    | color(int \value) // red, #000000, #888, rgb(0,0,255), rgb(0,0,255,0.5), hsl(120, 100%, 50%), hsla(120, 100%, 50%, 0.3)
    | expression(str \value) // (@TODO, when is this used?!)
    | frequency(num \value) // 12Hz, 14KhZ (No space between the number and the literal. Not supported by any browser so far)
    | function(str \value) // calc(100% - 100px), linear-gradient(red,yellow,blue). Example for content property: 'content: " (" attr(href) ")";'
    | ident(str \value) // left, auto, none
    | integer(int \value) // 1
    | length(num \value) // 10cm, 10.00pt, 10em
    | percent(num \value) // 10%, 10.00%
    | \list(list[Type] pair) // (@TODO, when is this used?!)
    | number(num \value) // 10.00
    | numeric(num \value) // Numbers specific for a certain unit like 10px. Superclass for angle, freuquency etc.
    | pair(tuple[Type, Type] pair) // Terms with a operator (COMMA, SPACE, SLASH) in between 
    | percent(num \value) // 10%
    | resolution(num \value) // 960dpi, 10dpcm, 20dppx
    | string(str \value) // "lol"
    | time(num \value) // 12s, +0s, -456ms
    | uri(str \value) // url("paper.jpg"), url(paper.jpg), url("http://nicasso.nl/assets/css/images/logo.png")
    ;

data Modifier
    = important() // !important
    ;
    
public Declaration createAstFromFile(loc file) {
    result = createAstsFromFiles({file});
    if ({oneResult} := result) {
        return oneResult;
    }
    throw "Unexpected number of ASTs returned from <file>";
}

@javaClass{org.rascalmpl.library.lang.css.m3.internal.CSSLoader}
@reflect{Need access to stderr and stdout}
public java set[Statement] createAstsFromFiles(set[loc] file);

@javaClass{org.rascalmpl.library.lang.css.m3.internal.CSSLoader}
@reflect{Need access to stderr and stdout}
public java Statement createAstFromString(str source);

public set[Declaration] createAstsFromDirectory(loc project) {
    if (!(isDirectory(project))) {
      throw "<project> is not a valid directory";
    }
    
    allCSSFiles = [ j | j <- find(project, "css"), isFile(j) ];
    return createAstsFromFiles(allCSSFiles);
}