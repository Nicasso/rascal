@contributor{ADT2PP}
module lang::css::m3::PrettyPrinter

// put relevant imports here: ADT definitions and all necessary ppx() functions!

public str ppx(Statement::stylesheet(str name, list[Statement] rules)) = "stylesheet(<name>,<ppx(rules)>)";
public str ppx(Statement::ruleSet(list[Type] selector, list[Declaration] declarations)) = "ruleSet(<ppx(selector)>,<ppx(declarations)>)";
public str ppx(Statement::ruleMedia(list[Type] mediaQueries, list[Statement] ruleSets)) = "ruleMedia(<ppx(mediaQueries)>,<ppx(ruleSets)>)";
public str ppx(Statement::ruleFontFace(list[Declaration] decs)) = "ruleFontFace(<ppx(decs)>)";
public str ppx(Statement::ruleImport(str uri)) = "ruleImport(<uri>)";
public str ppx(Statement::ruleCounterStyle(str name, list[Declaration] decs)) = "ruleCounterStyle(<name>,<ppx(decs)>)";
public str ppx(Statement::ruleNameSpace(str prefix, str uri)) = "ruleNameSpace(<prefix>,<uri>)";
public str ppx(Statement::ruleNameSpace(str uri)) = "ruleNameSpace(<uri>)";
public str ppx(Statement::ruleKeyframes(str name, list[Statement] ruleSets)) = "ruleKeyframes(<name>,<ppx(ruleSets)>)";
public str ppx(Statement::ruleMargin(Expression atRule, Statement stat)) = "ruleMargin(<ppx(atRule)>,<ppx(stat)>)";
public str ppx(Statement::rulePage(str pseudo, list[Declaration] declarations)) = "rulePage(<pseudo>,<ppx(declarations)>)";
public str ppx(Statement::ruleViewport(list[Declaration] declarations)) = "ruleViewport(<ppx(declarations)>)";
public str ppx(Statement::comment(str text)) = "comment(<text>)";
public default str ppx(Statement smth) = "??<smth>??";

public str ppx(Declaration::declaration(str property, list[Type] values)) = "declaration(<property>,<ppx(values)>)";
public default str ppx(Declaration smth) = "??<smth>??";

public str ppx(Expression::selector(list[Type] simpleSelectors)) = "selector(<ppx(simpleSelectors)>)";
public str ppx(Expression::selector(list[Type] simpleSelectors, str combinator)) = "selector(<ppx(simpleSelectors)>,<combinator>)";
public str ppx(Expression::mediaExpression(str property, list[Type] values)) = "mediaExpression(<property>,<ppx(values)>)";
public default str ppx(Expression smth) = "??<smth>??";

public str ppx(Type::class(str name)) = "class(<name>)";
public str ppx(Type::id(str name)) = "id(<name>)";
public str ppx(Type::domElement(str name)) = "domElement(<name>)";
public str ppx(Type::combinedSelector(list[Expression] selectors)) = "combinedSelector(<ppx(selectors)>)";
//public str ppx(Type::attributeSelector(str attribute, str op, str value)) = "attributeSelector(<attribute>,<op>,<value>)";
public str ppx(Type::attributeSelector(str attribute)) = "attributeSelector(<attribute>)";
public str ppx(Type::pseudoClass(str class)) = "pseudoClass(<class>)";
public str ppx(Type::audio(int aud, str unit)) = "audio(<aud>,<unit>)";
public str ppx(Type::angle(int angle, str unit)) = "angle(<angle>,<unit>)";
public str ppx(Type::color(int red, int green, int blue, int alpha)) = "color(<red>,<green>,<blue>,<alpha>)";
public str ppx(Type::expression(str expression)) = "expression(<expression>)";
public str ppx(Type::calc(str expression)) = "calc(<expression>)";
public str ppx(Type::frequency(int freq, str unit)) = "frequency(<freq>,<unit>)";
public str ppx(Type::function(str func, list[Type] exp)) = "function(<func>,<ppx(exp)>)";
public str ppx(Type::ident(str ident)) = "ident(<ident>)";
public str ppx(Type::integer(int val)) = "integer(<val>)";
public str ppx(Type::length(int len, str unit)) = "length(<len>,<unit>)";
public str ppx(Type::percent(int perc)) = "percent(<perc>)";
//public str ppx(Type::list(list[Type] pair)) = "list(<ppx(pair)>)";
public str ppx(Type::number(int number)) = "number(<number>)";
public str ppx(Type::resolution(int res, str unit)) = "resolution(<res>,<unit>)";
public str ppx(Type::string(str string)) = "string(<string>)";
public str ppx(Type::time(int time, str unit)) = "time(<time>,<unit>)";
public str ppx(Type::uri(str uri)) = "uri(<uri>)";
//public str ppx(Type::mediaQuery(str type, list[Expression] expressions)) = "mediaQuery(<type>,<ppx(expressions)>)";
public default str ppx(Type smth) = "??<smth>??";

public str ppx(Modifier::important()) = "important()";
public default str ppx(Modifier smth) = "??<smth>??";

