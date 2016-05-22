@contributor{ADT2PP}
module lang::css::m3::AST

extend analysis::m3::AST;

import util::FileSystem;
import lang::css::m3::TypeSymbol;
import IO;
import Set;
import String;
import List;
import util::Math;

anno str Type@op;

data Statement
	// Rulesets
    = stylesheet(str name, list[Statement] rules) // #lol { color: red; } #lal { color: blue; }
    | ruleSet(list[Type] selector, list[Declaration] declarations) // #lol { color: red; } (selector is a list because "#lol, #hi, #hej" are 3 individual selectors) (@TODO selector is a list of types because of the combinedSelector)
    // At rules
    | ruleMedia(list[Type] mediaQueries, list[Statement] ruleSets) // @media only screen and (max-width : 480px) {
    | ruleFontFace(list[Declaration] decs) // @font-face { (TODO WHY IS THIS A LIST OF DECLARATIONS?! AND NOT A STATEMENT)
    | ruleImport(str uri) // @import url("style2.css");
    | ruleImport(str uri, list[Type] mediaQueries) // @import url("style2.css") handheld and (max-width: 400px);
    | ruleCounterStyle(str name, list[Declaration] decs)
    | ruleNameSpace(str prefix, str uri)
    | ruleNameSpace(str uri)
    | ruleCharset(str name)
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
    | \color(int red, int green, int blue, num alpha) // red, #000000, #888, rgb(0,0,255), rgb(0,0,255,0.5), hsl(120, 100%, 50%), hsla(120, 100%, 50%, 0.3)
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

public void exportCSSToFile(loc file, Statement stylesheet) {
	writeFile(file, trim(ppx(stylesheet)));
}

public void prettyPrint(Statement stylesheet) {
	print(trim(ppx(stylesheet))+"\n");
}

int statementTabCount = 0;

public void increaseTabs() {
	statementTabCount = statementTabCount + 1;
}

public void decreaseTabs() {
	statementTabCount = statementTabCount - 1;
}

public str formatNumber(num number, str unit) { 
	if (number != 0) {
		if (round(number) == number) {
			return "<round(number)><unit>";
		} else {
			return "<number><unit>";
		}
	} else {
		return "0";
	}
}

public str getTabs() {
	int n = 0;
	str tabs = "";
	while( n < statementTabCount ) {
		tabs += "\t";
		n = n + 1;
	}
	return tabs;
}

public str pp(list[Statement] rules) {
	str result = "";
	for (Statement rule <- rules) {
		result += "<ppx(rule)>";
	}
	return result;
}

public str ppSelectors(list[Type] selector) {
	str result = "";
	for (Type sel <- selector) {
		result += "<ppx(sel)>";
	}
	return trim(result);
}

public str ppSelectors(list[Type] selector, str combinator) {
	str result = "";
	
	if(combinator == "ADJACENT") {
		combinator = "+";
	} else if(combinator == "CHILD") {
		combinator = "\>";
	} else if(combinator == "PRECEDING") {
		combinator = "~";
	} else {
		combinator = " ";	
	}

	for (Type sel <- selector) {
		if (stringChar(charAt(ppx(sel), 0)) == ":") {
			result += "<ppx(sel)>";
		} else {
			result += " <combinator><ppx(sel)>";
		}
		
	}
	return result;
}

public str ppExpressions(list[Type] selector) {
	str result = "";
	for (Type sel <- selector) {
		result += "<ppx(sel)>";
	}
	return result;
}

public str ppValues(list[Type] vals) {
	str result = "";
	for (Type val <- vals) {
		if (val@op?) {
			result += "<val@op><ppx(val)>";
		} else {
			result += " <ppx(val)>";
		}
	}
	return trim(result);
}

public str ppMediaQueries(list[Type] selector) {
	str result = "";
	for (Type sel <- selector) {
		result += "<ppx(sel)>";
	}
	return result;
}

public str pp(list[Declaration] declarations) {
	str result = "";
	for (Declaration decl <- declarations) {
		result += "<ppx(decl)>";
	}
	return result;
}

public str pp(Expression atRule) {
	return ppx(atRule);
}

public str pp(Statement stat) {
	return ppx(stat);
}

public str pp(Type t) {
	return ppx(t);
}

public str ppMediaQueryExpressions(list[Expression] selectors) {
	str result = "";
	for (Expression sel <- selectors) {
		result += "(<ppx(sel)>)";
	}
	return result;
}

public str pp(list[Expression] selectors) {
	str result = "";
	for (Expression sel <- selectors) {
		result += "<ppx(sel)>";
	}
	return result;
}

public str ppCombinatedSelectors(list[Type] selectors) {
	str result = "";
	int i = 0;
	for (Type sel <- selectors) {
		result += "<ppx(sel)>";
		if (i < size(selectors)-1) {
			result += ",";
		}
		i = i + 1;
		
	}
	return trim(result);
}

public str ppx(Statement::stylesheet(str name, list[Statement] rules)) = pp(rules);
public str ppx(Statement::ruleSet(list[Type] selector, list[Declaration] declarations)) = "<getTabs()><ppCombinatedSelectors(selector)> {\n<pp(declarations)><getTabs()>}\n\n";
public str ppx(Statement::ruleMedia(list[Type] mediaQueries, list[Statement] ruleSets)) {
	
	str result = "";
	result += "<getTabs()>@media <ppMediaQueries(mediaQueries)> {\n";
	increaseTabs();
	result += "<pp(ruleSets)>}\n\n";
	decreaseTabs();
	
	return result;
}
public str ppx(Statement::ruleFontFace(list[Declaration] decs)) = "<getTabs()>@font-face {\n<pp(decs)>}\n\n";
public str ppx(Statement::ruleImport(str uri)) = "<getTabs()>@import <uri>;\n\n";
public str ppx(Statement::ruleImport(str uri, list[Type] mediaQueries)) = "<getTabs()>@import <uri> <ppMediaQueries(mediaQueries)>;\n\n";
public str ppx(Statement::ruleCounterStyle(str name, list[Declaration] decs)) = "<getTabs()>@counter-style <name> {\n<pp(decs)>}\n\n";
public str ppx(Statement::ruleNameSpace(str prefix, str uri)) = "<getTabs()>@namespace <prefix> <uri>;\n\n";
public str ppx(Statement::ruleNameSpace(str uri)) = "<getTabs()>@namespace <uri>;\n\n";
public str ppx(Statement::ruleCharset(str name)) = "<getTabs()>@charset <name>;\n\n";
public str ppx(Statement::ruleKeyframes(str name, list[Statement] ruleSets)) {
	
	str result = "";
	result += "<getTabs()>@keyframes <name> {\n";
	increaseTabs();
	result += "<pp(ruleSets)>}\n\n";
	decreaseTabs();
	
	return result;
}

public str ppx(Statement::ruleMargin(Expression atRule, Statement stat)) = "<getTabs()>@margin <pp(atRule)>{\n<pp(stat)>}\n\n";
public str ppx(Statement::rulePage(str pseudo, list[Declaration] declarations)) = "<getTabs()>@page <pseudo> {\n<pp(declarations)>}\n\n";
public str ppx(Statement::ruleViewport(list[Declaration] declarations)) = "<getTabs()>@viewport {\n<pp(declarations)>}\n\n";
public str ppx(Statement::comment(str text)) = "<getTabs()><text>\n\n";
public default str ppx(Statement smth) = "??<smth>??";

public str ppx(Declaration::declaration(str property, list[Type] values)) = "<getTabs()>\t<property>: <ppValues(values)>;\n";
public default str ppx(Declaration smth) = "??<smth>??";

public str ppx(Expression::selector(list[Type] simpleSelectors)) = "<ppSelectors(simpleSelectors)>";
public str ppx(Expression::selector(list[Type] simpleSelectors, str combinator)) = "<ppSelectors(simpleSelectors, combinator)>";
public str ppx(Expression::mediaExpression(str property, list[Type] values)) = "<property>: <ppExpressions(values)>";
public default str ppx(Expression smth) = "??<smth>??";

public str ppx(Type::class(str name)) = " <name>";
public str ppx(Type::id(str name)) = " <name>";
public str ppx(Type::domElement(str name)) = " <name>";
public str ppx(Type::combinedSelector(list[Expression] selectors)) = " <pp(selectors)>";
public str ppx(Type::attributeSelector(str attribute, str op, str \value)) = "[<attribute><op><\value>]";
public str ppx(Type::attributeSelector(str attribute)) = "[<attribute>]";
public str ppx(Type::pseudoClass(str class)) = ":<class>";
public str ppx(Type::audio(num aud, str unit)) = formatNumber(aud, unit);
public str ppx(Type::angle(num angle, str unit)) = formatNumber(angle, unit);
public str ppx(Type::color(int red, int green, int blue, num alpha)) = "rgba(<red>,<green>,<blue>,<formatNumber(alpha,"")>)";
public str ppx(Type::expression(str expression)) = "expression(<expression>)";
public str ppx(Type::calc(str expression)) = "calc(<expression>)";
public str ppx(Type::frequency(num freq, str unit)) = formatNumber(freq, unit);
public str ppx(Type::function(str func, list[Type] exp)) = "<func>(<ppExpressions(exp)>)";
public str ppx(Type::ident(str ident)) = "<ident>";
public str ppx(Type::integer(int val)) = "<val>";
public str ppx(Type::length(num len, str unit)) = formatNumber(len, unit);
public str ppx(Type::percent(num perc)) = formatNumber(perc, "%");
public str ppx(Type::\list(list[Type] pair)) = "<ppExpressions(pair)>";
public str ppx(Type::number(num number)) = formatNumber(number, "");
public str ppx(Type::resolution(num res, str unit)) = formatNumber(res, unit);
public str ppx(Type::string(str string)) = "<string>";
public str ppx(Type::time(num time, str unit)) = formatNumber(time, unit);
public str ppx(Type::uri(str uri)) = "<uri>";
public str ppx(Type::mediaQuery(str \type, list[Expression] expressions)) {
	
	str result = "";
	result += "<\type>";
	str exp = trim(ppMediaQueryExpressions(expressions));
	if (exp != "") {
		result += " and <trim(ppMediaQueryExpressions(expressions))>";
	}
	
	return result;
}
// = "<\type> <trim(ppMediaQueryExpressions(expressions))>";
public default str ppx(Type smth) = "??<smth>??";

public str ppx(Modifier::important()) = "!important";
public default str ppx(Modifier smth) = "??<smth>??";