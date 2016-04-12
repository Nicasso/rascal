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
    = stylesheet(list[Statement] rules) // #lol { color: red; } #lal { color: blue; }
    | ruleSet(list[Type] selector, list[Declaration] declarations) // #lol { color: red; } (selector is a list because "#lol, #hi, #hej" are 3 individual selectors) (@TODO selector is a list of types because of the combinedSelector)
    // At rules
    | ruleMedia(list[Type] mediaQueries, list[Statement] ruleSets) // @media only screen and (max-width : 480px) {
    | ruleFontFace(list[Declaration] decs) // @font-face { (TODO WHY IS THIS A LIST OF DECLARATIONS?! AND NOT A STATEMENT)
    | ruleImport(Type uri) // @import url("style2.css");
    | ruleMargin(Expression atRule, Statement stat) // (@TODO, never heard of this!)
    | rulePage(str pseudo, list[Declaration] declarations) // @page :left { "delcarations here" }
    | ruleViewport(list[Declaration] declarations) // @viewport { "delcarations here" }
    ;

data Declaration
    = declaration(str property, list[Type] values) // color: red;, background: url('logo.png') no-repeat;
    ;

data Expression 
    = selector(list[Type] simpleSelectors) // Combinator is not present with the first selector part, so made it optional by adding the rule below.
    | selector(list[Type] simpleSelectors, str combinator) // See Type Selector, it is a list because ".hi #there" or ".hi > div" is one complete selector
    | mediaExpression(str property, list[Type] values) // (max-width : 480px) and (orientation: landscape) in mediaqueries like "@media tv and (min-width: 700px) and (orientation: landscape)"
    ;

data Type 
	// Selector
    = class(str name) // .lol
    | id(str name) // #lol
    | domElement(str name) // div
    | combinedSelector(list[Expression] selectors) // .lol.hej.you, #hej.you, #hi#there (single element with all noted attributes)
    | attributeSelector(str attribute, str op, str \value) // div[class*="post"] (This rule only relates to the [class*="post"] part)
    | pseudoClass(str class) // :after, :link, :first-child
    // Values
    | \angle(num angle, str unit) // 10deg, 10grad, 1rad, 0.25turn
    | \color(int red, int green, int blue, int alpha) // red, #000000, #888, rgb(0,0,255), rgb(0,0,255,0.5), hsl(120, 100%, 50%), hsla(120, 100%, 50%, 0.3)
    | \expression(str expression) // top: expression(body.scrollTop + 50 + "px");
    | \frequency(num freq, str unit) // 12Hz, 14KhZ (No space between the number and the literal! Not supported by any browser so far)
    | \function(str func, list[Type] exp) // calc(100% - 100px), linear-gradient(red,yellow,blue). Example for content property: 'content: " (" attr(href) ")";'
    | \ident(str ident) // left, auto, none
    | \integer(int \val) // 1
    | \length(num \len, str unit) // 10cm, 10.00pt, 10em, etc.
    | \percent(num \perc) // 10%, 10.00%
    | \list(list[Type] pair) // (@TODO, when is this ever used?!)
    | \number(num number) // 10.00
    | \resolution(num \res, str unit) // 960dpi, 10dpcm, 20dppx
    | \string(str \string) // "lol"
    | \time(num \time, str unit) // 12s, +0s, -456ms
    | \uri(str \uri) // url("paper.jpg"), url(paper.jpg), url("http://nicasso.nl/assets/css/images/logo.png")
    // Exotics
    | \mediaQuery(str \type, list[Expression] expressions) // @media tv and (min-width: 700px) and (orientation: landscape) where "tv" is the type and "orientation: landscape" is a mediaExpression
    ;

data Modifier
    = important() // !important (Will be added as @modifier annotation to declarations like the Java m3 does)
    ;
    
public Statement createAstFromFile(loc file) {
    result = createAstsFromFiles({file});
    if ({oneResult} := result) {
        return oneResult;
    }
    throw "Unexpected number of ASTs returned from <file>";
}

public set[Statement] createAstsFromDirectory(loc project) {
    if (!(isDirectory(project))) {
      throw "<project> is not a valid directory";
    }
    
    allCSSFiles = { j | j <- find(project, "css"), isFile(j) };
    return createAstsFromFiles(allCSSFiles);
}

@javaClass{org.rascalmpl.library.lang.css.m3.internal.ast.ASTLoader}
@reflect{Need access to stderr and stdout}
public java set[Statement] createAstsFromFiles(set[loc] file);

@javaClass{org.rascalmpl.library.lang.css.m3.internal.ast.ASTLoader}
@reflect{Need access to stderr and stdout}
public java Statement createAstFromString(str source);