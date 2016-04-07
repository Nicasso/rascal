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
    | ruleSet(list[Expression] selector, list[Declaration] declarations) // #lol { color: red; } (selector is a list because "#lol, #hi, #hej" are 3 individual selectors)
    // At rules
    | ruleMedia(Expression mediaQueries, Statement \value) // @media only screen and (max-width : 480px) {
    | ruleFontFace(Statement \value) // @font-face {
    | ruleImport(Type uri) // @import url("style2.css");
    | ruleMargin(Expression atRule, Statement \value) // (@TODO, when is this used?!)
    | rulePage(Expression atRule, Statement \value) // @page :left {
    | ruleViewport(Statement \value) // @viewport {
    ;

data Declaration
    = declaration(Expression property, Expression exp) // color: red;, background: url('logo.png') no-repeat;
    ;

data Expression 
    = selector(list[Type] selectors) // See Type Selector, it is a list because ".hi #there" or ".hi > div" is one complete selector
    | property(str property) // border, color, width, font etc.
    | \value(list[Type] \values) // See type Values
    ;

data Type 
	// Selector
    = class(str name, list[Type] optional) // .lol (Optional is meant for the attributeSelectors and pseudoClasses)
    | id(str name, list[Type] optional) // #lol (Optional is meant for the attributeSelectors and pseudoClasses)
    | domElement(str name, list[Type] optional) // div (Optional is meant for the attributeSelectors and pseudoClasses)
    | combinator(str name) // child selector (>), adjacent sibling selector (+), general sibling selector (~), descendant selector (space)
    | combinedSelector(list[Type] selectors) // .lol.hej.you, #hej.you, #hi#there (single element with all noted attributes)
    | attributeSelectors(Type attribute, Type \value) // div[class*="post"] (This rule only relates to the [class*="post"] part)
    | pseudoClasses(str class) // :after, :link, :first-child
    // Values
    | angle(int angle, str unit) // 10deg, 10grad, 1rad, 0.25turn
    | color(int color, str unit) // red, #000000, #888, rgb(0,0,255), rgb(0,0,255,0.5), hsl(120, 100%, 50%), hsla(120, 100%, 50%, 0.3)
    | expression(str expr) // (@TODO, when is this ever used?!)
    | frequency(num freq, str unit) // 12Hz, 14KhZ (No space between the number and the literal. Not supported by any browser so far)
    | function(str func, list[Type] expr) // calc(100% - 100px), linear-gradient(red,yellow,blue). Example for content property: 'content: " (" attr(href) ")";'
    | ident(str ident) // left, auto, none
    | integer(int \val) // 1
    | length(num \len, str unit) // 10cm, 10.00pt, 10em, etc.
    | percent(num \perc) // 10%, 10.00%
    | \list(list[Type] pair) // (@TODO, when is this used?!)
    | number(num number) // 10.00
    | numeric(num number) // Numbers specific for a certain unit like 10px. Superclass for angle, freuquency etc. @TODO, do we need this here since it is a superclas??
    | pair(tuple[Type, Type] values) // Terms with a operator (COMMA, SPACE, SLASH) in between 
    | resolution(num \res, str unit) // 960dpi, 10dpcm, 20dppx
    | string(str \string) // "lol"
    | time(num \time, str unit) // 12s, +0s, -456ms
    | uri(str \uri) // url("paper.jpg"), url(paper.jpg), url("http://nicasso.nl/assets/css/images/logo.png")
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