@contributor{ADT2PP}
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
    = stylesheet(str name, list[Statement] rules) // #lol { color: red; } #lal { color: blue; }
    | ruleSet(list[Type] selector, list[Declaration] declarations) // #lol { color: red; } (selector is a list because "#lol, #hi, #hej" are 3 individual selectors) (@TODO selector is a list of types because of the combinedSelector)
    // At rules
    | ruleMedia(list[Type] mediaQueries, list[Statement] ruleSets) // @media only screen and (max-width : 480px) {
    | ruleFontFace(list[Declaration] decs) // @font-face { (TODO WHY IS THIS A LIST OF DECLARATIONS?! AND NOT A STATEMENT)
    | ruleImport(str uri) // @import url("style2.css");
    | ruleCounterStyle(str name, list[Declaration] decs)
    | ruleNameSpace(str prefix, str uri)
    | ruleNameSpace(str uri)
    | ruleKeyframes(str name, list[Statement] ruleSets)
    | ruleMargin(Expression atRule, Statement stat) // (@TODO, never heard of this!)
    | rulePage(str pseudo, list[Declaration] declarations) // @page :left { "delcarations here" }
    | ruleViewport(list[Declaration] declarations) // @viewport { "delcarations here" }
    | comment(str text) // /* comment text here */
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
    | attributeSelector(str attribute) // div[disabled] (This rule only relates to the [disabled] part)
    | pseudoClass(str class) // :after, :link, :first-child
    // Values
    | \audio(num aud, str unit) // 10db, -10db
    | \angle(num angle, str unit) // 10deg, 10grad, 1rad, 0.25turn
    | \color(int red, int green, int blue, int alpha) // red, #000000, #888, rgb(0,0,255), rgb(0,0,255,0.5), hsl(120, 100%, 50%), hsla(120, 100%, 50%, 0.3)
    | \expression(str expression) // top: expression(body.scrollTop + 50 + "px");
    | \calc(str expression) // top: calc(100% - 50px);
    | \frequency(num freq, str unit) // 12Hz, 14KhZ (No space between the number and the literal! Not supported by any browser so far)
    | \function(str func, list[Type] exp) // url(lol.jpg), calc(100% - 100px), linear-gradient(red,yellow,blue). Example for content property: 'content: " (" attr(href) ")";'
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
public java Statement createAstFromString(str source, loc file = |unknown:///|);

// put relevant imports here: ADT definitions and all necessary pp() functions!

public str prettyPrint(Statement stylesheet) {
	return ppx(stylesheet);
}

public str pp(list[Statement] rules) {
	str result = "";
	for (Statement rule <- rules) {
		result = result + ppx(rule);
	}
	return result;
}

public str pp(list[Type] selector) {
	return "list[Type] selector";
}

public str pp(list[Declaration] declarations) {
	return "list[Declaration] declarations";
}

public str pp(list[Type] mediaQueries) {
	return "list[Type] mediaQueries";
}

public str pp(Expression atRule) {
	return "Expression atRule";
}

public str pp(Statement stat) {
	return "Statement stat";
}

public str pp(list[Expression] selectors) {
	return "list[Expression] selectors";
}

public str ppx(Statement::stylesheet(str name, list[Statement] rules)) = pp(rules);
public str ppx(Statement::ruleSet(list[Type] selector, list[Declaration] declarations)) = "ruleSet(<pp(selector)>,<pp(declarations)>)";
public str ppx(Statement::ruleMedia(list[Type] mediaQueries, list[Statement] ruleSets)) = "ruleMedia(<pp(mediaQueries)>,<pp(ruleSets)>)";
public str ppx(Statement::ruleFontFace(list[Declaration] decs)) = "ruleFontFace(<pp(decs)>)";
public str ppx(Statement::ruleImport(str uri)) = "ruleImport(<uri>)";
public str ppx(Statement::ruleCounterStyle(str name, list[Declaration] decs)) = "ruleCounterStyle(<name>,<pp(decs)>)";
public str ppx(Statement::ruleNameSpace(str prefix, str uri)) = "ruleNameSpace(<prefix>,<uri>)";
public str ppx(Statement::ruleNameSpace(str uri)) = "ruleNameSpace(<uri>)";
public str ppx(Statement::ruleKeyframes(str name, list[Statement] ruleSets)) = "ruleKeyframes(<name>,<pp(ruleSets)>)";
public str ppx(Statement::ruleMargin(Expression atRule, Statement stat)) = "ruleMargin(<pp(atRule)>,<pp(stat)>)";
public str ppx(Statement::rulePage(str pseudo, list[Declaration] declarations)) = "rulePage(<pseudo>,<pp(declarations)>)";
public str ppx(Statement::ruleViewport(list[Declaration] declarations)) = "ruleViewport(<pp(declarations)>)";
public str ppx(Statement::comment(str text)) = "comment(<text>)";
public default str ppx(Statement smth) = "??<smth>??";

public str ppx(Declaration::declaration(str property, list[Type] values)) = "declaration(<property>,<pp(values)>)";
public default str ppx(Declaration smth) = "??<smth>??";

public str ppx(Expression::selector(list[Type] simpleSelectors)) = "selector(<pp(simpleSelectors)>)";
public str ppx(Expression::selector(list[Type] simpleSelectors, str combinator)) = "selector(<pp(simpleSelectors)>,<combinator>)";
public str ppx(Expression::mediaExpression(str property, list[Type] values)) = "mediaExpression(<property>,<pp(values)>)";
public default str ppx(Expression smth) = "??<smth>??";

public str ppx(Type::class(str name)) = "class(<name>)";
public str ppx(Type::id(str name)) = "id(<name>)";
public str ppx(Type::domElement(str name)) = "domElement(<name>)";
public str ppx(Type::combinedSelector(list[Expression] selectors)) = "combinedSelector(<pp(selectors)>)";
public str ppx(Type::attributeSelector(str attribute, str op, str \value)) = "attributeSelector(<attribute>,<op>,<\value>)";
public str ppx(Type::attributeSelector(str attribute)) = "attributeSelector(<attribute>)";
public str ppx(Type::pseudoClass(str class)) = "pseudoClass(<class>)";
public str ppx(Type::audio(int aud, str unit)) = "audio(<aud>,<unit>)";
public str ppx(Type::angle(int angle, str unit)) = "angle(<angle>,<unit>)";
public str ppx(Type::color(int red, int green, int blue, int alpha)) = "color(<red>,<green>,<blue>,<alpha>)";
public str ppx(Type::expression(str expression)) = "expression(<expression>)";
public str ppx(Type::calc(str expression)) = "calc(<expression>)";
public str ppx(Type::frequency(int freq, str unit)) = "frequency(<freq>,<unit>)";
public str ppx(Type::function(str func, list[Type] exp)) = "function(<func>,<pp(exp)>)";
public str ppx(Type::ident(str ident)) = "ident(<ident>)";
public str ppx(Type::integer(int val)) = "integer(<val>)";
public str ppx(Type::length(int len, str unit)) = "length(<len>,<unit>)";
public str ppx(Type::percent(int perc)) = "percent(<perc>)";
public str ppx(Type::\list(list[Type] pair)) = "list(<pp(pair)>)";
public str ppx(Type::number(int number)) = "number(<number>)";
public str ppx(Type::resolution(int res, str unit)) = "resolution(<res>,<unit>)";
public str ppx(Type::string(str string)) = "string(<string>)";
public str ppx(Type::time(int time, str unit)) = "time(<time>,<unit>)";
public str ppx(Type::uri(str uri)) = "uri(<uri>)";
public str ppx(Type::mediaQuery(str \type, list[Expression] expressions)) = "mediaQuery(<\type>,<pp(expressions)>)";
public default str ppx(Type smth) = "??<smth>??";

public str ppx(Modifier::important()) = "important()";
public default str ppx(Modifier smth) = "??<smth>??";