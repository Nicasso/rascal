module lang::css::m3::PrettyPrinter

import lang::css::m3::AST;

import util::FileSystem;
import lang::css::m3::TypeSymbol;
import IO;
import Set;
import String;
import List;
import util::Math;

private int statementTabCount = 0;

public void increaseTabs() {
	statementTabCount += 1;
}

public void decreaseTabs() {
	statementTabCount -=1;
}

public void exportCSSToFile(loc file, Statement stylesheet) = writeFile(file, trim(ppx(stylesheet)));

public void prettyPrint(Statement stylesheet) =	print(trim(ppx(stylesheet))+"\n");

public str formatNumber(num number, str unit) { 
	if (number != 0) {
		if (round(number) == number) {
			return "<round(number)><toLowerCase(unit)>";
		} else {
			return "<number><toLowerCase(unit)>";
		}
	} else {
		return "0";
	}
}

public str getTabs() {
	int n = 0;
	str tabs = "";
	while ( n < statementTabCount ) {
		tabs += "\t";
		n = n + 1;
	}
	return tabs;
}

public str formatComment(str comment) {
	comment = replaceAll(comment,"  ","");
	comment = replaceAll(comment,"\t","");
	comment = replaceAll(comment,"\n","\n<getTabs()>");
	return "<getTabs()><comment>\n";
}

public str decimal2hex(int d) {
    str digits = "0123456789ABCDEF";
    if (d == 0) { 
    	return "00";
    }
    str hex = "";
    while (d > 0) {
        int digit = d % 16;
        hex = stringChar(charAt(digits, digit)) + hex;
        d = d / 16;
    }
    if (size(hex) == 1) {
    	return "0<hex>";
    }
    return hex;
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
	for (Declaration decl <- sort(declarations)) {
		result += "<ppx(decl)>";
	}
	return result;
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

public str ppCombinatedSelectors(list[Expression] selectors) {
	str result = "";
	int i = 0;
	for (Expression sel <- selectors) {
		result += "<ppx(sel)>";
		if (i < size(selectors)-1) {
			result += ",\n";
		}
		i = i + 1;
		
	}
	return trim(result);
}

// Statements
public str ppx(ss:Statement::stylesheet(str name, list[Statement] rules)) {
	str result = "";
	if (ss@comment?) {
		result += formatComment(ss@comment);
	}
	result += pp(rules);
	return result;
}
public str ppx(rs:Statement::ruleSet(list[Expression] selector, list[Declaration] declarations)) {
	str result = "";
	if (rs@comment?) {
		result += formatComment(rs@comment);	
	}
	result += "<getTabs()><ppCombinatedSelectors(selector)> {\n<pp(declarations)><getTabs()>}\n\n";
	return result;
}
public str ppx(rm:Statement::ruleMedia(list[Type] mediaQueries, list[Statement] ruleSets)) {
	str result = "";
	if(rm@comment?) {
		result += formatComment(rm@comment);	
	}
	result += "<getTabs()>@media <ppMediaQueries(mediaQueries)> {\n";
	increaseTabs();
	result += "<pp(ruleSets)>}\n\n";
	decreaseTabs();
	return result;
}
public str ppx(rf:Statement::ruleFontFace(list[Declaration] decs)) {
	str result = "";
	if (rf@comment?) {
		result += formatComment(rf@comment);
	 }
	result += "<getTabs()>@font-face {\n<pp(decs)>}\n\n";
	return result;
}
public str ppx(ri:Statement::ruleImport(str uri)) {
 str result = "";
 
 if (ri@comment?) {
	result += formatComment(ri@comment);
 }
 result += "<getTabs()>@import <uri>;\n\n";
 
 return result;
}
public str ppx(ri:Statement::ruleImport(str uri, list[Type] mediaQueries)) {
	str result = "";
	if (ri@comment?) {
		result += formatComment(ri@comment);
	 }
	result += "<getTabs()>@import <uri> <ppMediaQueries(mediaQueries)>;\n\n";
	return result;
}
public str ppx(rc:Statement::ruleCounterStyle(str name, list[Declaration] decs)) {
	str result = "";
	if (rc@comment?) {
		result += formatComment(rc@comment);
	 }
	result += "<getTabs()>@counter-style <name> {\n<pp(decs)>}\n\n";
	return result;
}
public str ppx(rn:Statement::ruleNameSpace(str prefix, str uri)) {
	str result = "";
	if (rn@comment?) {
		result += formatComment(rn@comment);
	 }
	result += "<getTabs()>@namespace <prefix> <uri>;\n\n";
	return result;
}
public str ppx(rn:Statement::ruleNameSpace(str uri)) {
	str result = "";
	if (rn@comment?) {
		result += formatComment(rn@comment);
	 }
	result += "<getTabs()>@namespace <uri>;\n\n";
	return result;
}
public str ppx(rc:Statement::ruleCharset(str name)) {
	str result = "";
	if (rc@comment?) {
		result += formatComment(rc@comment);
	 }
	result += "<getTabs()>@charset <name>;\n\n";
	return result;
}
public str ppx(rk:Statement::ruleKeyframes(str name, list[Statement] ruleSets)) {
	str result = "";
	if (rk@comment?) {
		result += formatComment(rk@comment);
	}
	result += "<getTabs()>@keyframes <name> {\n";
	increaseTabs();
	result += "<pp(ruleSets)>}\n\n";
	decreaseTabs();
	return result;
}
public str ppx(rp:Statement::rulePage(str pseudo, list[Declaration] declarations)) {
	str result = "";
	if (rp@comment?) {
		result += formatComment(rp@comment);
	 }
	result += "<getTabs()>@page <pseudo> {\n<pp(declarations)>}\n\n";
	return result;
}
public str ppx(rv:Statement::ruleViewport(list[Declaration] declarations)) {
	str result = "";
	if (rv@comment?) {
		result += formatComment(rv@comment);
	 }
	result += "<getTabs()>@viewport {\n<pp(declarations)>}\n\n";
	return result;
}
public default str ppx(Statement smth) = "??<smth>??";

// Declarations
public str ppx(d:Declaration::declaration(str property, list[Type] values)) {
	str result = "";
	increaseTabs();
	if (d@comment?) {
		result += formatComment(d@comment);
	}
	if (d@modifier?) {
 		result += "<getTabs()><toLowerCase(property)>: <ppValues(values)> !<d@modifier>;\n";
 	} else {
 		result +=  "<getTabs()><toLowerCase(property)>: <ppValues(values)>;\n";
 	}
 	decreaseTabs();
 	return result;
}
public default str ppx(Declaration smth) = "??<smth>??";

// Expressions

public str ppx(Type::combinedSelector(list[Expression] selectors)) { 
	str result = "";
	for(sel <- selectors) {
		result  += "<pp(selectors)>";
	}
	return result;
}

public str ppx(s:Expression::selector(list[Type] simpleSelector)) {
	str result = "";
	
	// @TODO real combinator (modifier) node is not used here...
	if (s@combinator?) {
		switch(s@combinator) {
			case "descendant": result += " ";
			case "adjacent": result += " + ";
			case "preceding": result += " ~ ";
			case "child": result += " \> ";
		} 
	} else {
		result += " ";
	}
	
	result += "<ppSelectors(simpleSelector)>";
	 
	return result;
}

public str ppx(Expression::mediaExpression(str property, list[Type] values)) = "<property>: <ppExpressions(values)>";
public default str ppx(Expression smth) = "??<smth>??";

// Types
public str ppx(Type::class(str name)) = " <name>";
public str ppx(Type::id(str name)) = " <name>";
public str ppx(Type::domElement(str name)) = " <name>";
public str ppx(Type::attributeSelector(str attribute, str op, str \value)) = "[<attribute><op><\value>]";
public str ppx(Type::attributeSelector(str attribute)) = "[<attribute>]";
public str ppx(Type::pseudoClass(str class)) = ":<class>";
public str ppx(Type::pseudoElement(str elem)) = "::<elem>";

public str ppx(Type::audio(num aud, str unit)) = formatNumber(aud, unit);
public str ppx(Type::angle(num angle, str unit)) = formatNumber(angle, unit);
public str ppx(Type::color(int red, int green, int blue, num alpha)) {
	if (alpha < 1) {
 		return "rgba(<red>,<green>,<blue>,<formatNumber(alpha,"")>)";
 	} else {
 		return "#<decimal2hex(red)><decimal2hex(green)><decimal2hex(blue)>";
 	}
}
public str ppx(Type::expression(str expression)) = "expression(<expression>)";
public str ppx(Type::calc(str expression)) = "calc(<expression>)";
public str ppx(Type::frequency(num freq, str unit)) = formatNumber(freq, unit);
public str ppx(Type::function(str func, list[Type] exp)) = "<toLowerCase(func)>(<ppExpressions(exp)>)";
public str ppx(Type::ident(str ident)) = "<toLowerCase(ident)>";
public str ppx(Type::integer(int val)) = "<val>";
public str ppx(Type::length(num len, str unit)) = formatNumber(len, unit);
public str ppx(Type::percent(num perc)) = formatNumber(perc, "%");
public str ppx(Type::number(num number)) = formatNumber(number, "");
public str ppx(Type::resolution(num res, str unit)) = formatNumber(res, unit);
public str ppx(Type::string(str string)) {
	return replaceAll(toLowerCase(string), "\"", "\'");
}
public str ppx(Type::time(num time, str unit)) = formatNumber(time, unit);
public str ppx(Type::uri(str uri)) {
	return replaceAll(uri, "\"", "");
}
public str ppx(Type::mediaQuery(str \type, list[Expression] expressions)) {
	str result = "";
	result += "<\type>";
	str exp = trim(ppMediaQueryExpressions(expressions));
	if (exp != "") {
		result += " and <trim(ppMediaQueryExpressions(expressions))>";
	}
	return result;
}
public default str ppx(Type smth) = "??<smth>??";

// Modifiers
public str ppx(Modifier::important()) = "!important";
public str ppx(Modifier::combinator(str combinator)) {
	return combinator;
}
public default str ppx(Modifier smth) = "??<smth>??";