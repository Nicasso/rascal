module lang::css::m3::Sandbox

import lang::css::m3::AST;
import lang::css::m3::Core;

import IO;
import String;
import Relation;
import Set;
import Map;
import Node;
import List;
import util::Math;

public void refactorExample1() {
	Statement stylesheet = createAstFromFile(|home:///Documents/workspace/testCSS/sandbox/style.css|);
	
	prettyPrint(stylesheet);
	
	newAST = visit (stylesheet) {
		case ruleSet(list[Type] selector, list[Declaration] declarations) => ruleSet(selector, marginShorthand(declarations))
	};
	
	iprintln("-----------------------------------------------");
	
	prettyPrint(newAST);
}

public list[Declaration] marginShorthand(list[Declaration] declarations) {
	requiredDeclarations = ["margin-left", "margin-right", "margin-top", "margin-bottom"];
	
	map[str, Type] declarationsValues = ();
	list[Declaration] newDeclarations = [];
	for (n <- declarations) {
		visit (n) {
			case declaration(str property, list[Type] values): {
				if (property in requiredDeclarations) {
					requiredDeclarations = requiredDeclarations - [property];
					declarationsValues += (property:values[0]);
					if (size(requiredDeclarations) == 0) {
						newDeclarations += declaration("margin", [declarationsValues["margin-top"],declarationsValues["margin-right"],declarationsValues["margin-bottom"],declarationsValues["margin-left"]]);
					}
				} else {
					newDeclarations += n;
				}
			}
		}
	}
	return newDeclarations;
}

public void basicAnalysis() {
	M3 stylesheet = createM3FromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	loc style = getOneFrom(stylesheets(stylesheet));
	
	map[str,int] values = ("code":0, "comment":0, "blank":0, "total":0);
	bool commentBlock = false;
	
	for (line <- readFileLines(style)) {	
		values["total"] += 1;
	
		if (trim(line) == "") {
			values["blank"] += 1;
		} else if (startsWith(trim(line),"/*")) {
			if (!endsWith(trim(line),"*/")) {
				commentBlock = true;
			}
			values["comment"] += 1;
		} else if (startsWith(trim(line),"*/") || endsWith(trim(line),"*/")) {
			commentBlock = false;
			values["comment"] += 1;
		} else if (commentBlock) {
			values["comment"] += 1;
		} else {
			values["code"] += 1;
		}
	}
	
	iprintln(values);	
}

public void selectorAnalysis() {
	Statement stylesheet = createAstFromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	map[str,int] values = ("classes":0, "ids":0, "elements":0);
	
	visit (stylesheet) {
		case class(str name): {
			values["classes"] += 1;
		}
		case id(str name): {
			values["ids"] += 1;
		}
    	case domElement(str name): {
    		values["elements"] += 1;
    	}
	};
	
	iprintln(values);
	
}

public void selectorAnalysis2() {
	Statement stylesheet = createAstFromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	map[str,int] values = ("selectors":0, "total":0, "min":1, "max":0, "average":0);
	
	visit (stylesheet) {
		case combinedSelector(list[Expression] selectors): {
			values["total"] += size(selectors);
			values["selectors"] += 1;
			if (size(selectors) > values["max"]) {
				values["max"] = size(selectors);
			}
			if (size(selectors) < values["min"]) {
				values["min"] = size(selectors);
			}
		}
	};
	
	values["average"] = values["total"]/values["selectors"];
	
	iprintln(values);
	
}

public void declarationAnalysis() {
	Statement stylesheet = createAstFromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	lrel[str,int] values = [];
	
	visit (stylesheet) {
		case declaration(str property, list[Type] declarationValues): {
			if (size(values[property]) == 0) {
				values += [<property,1>];
			} else {
				//iprintln(<property,values[property][0]>);
				int val = (values[property][0])+1;
				values = values - [<property,values[property][0]>];
				values += [<property,val>];
			}
		}
	};
	
	iprintln(sort(values));
}
/**
 * From the paper: Complexity Metrics for Cascading Style Sheets
 */
public void ruleLength() {
	M3 stylesheet = createM3FromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	set[loc] rules = ruleSets(stylesheet);
	
	int ruleLength = 0;
	bool commentBlock = false;
	for (rule <- rules) {
		for (line <- readFileLines(rule)) {	
			if (trim(line) == "") {
				int a;
			} else if (startsWith(trim(line),"/*")) {
				if (!endsWith(trim(line),"*/")) {
					commentBlock = true;
				}
				int a;
			} else if (startsWith(trim(line),"*/") || endsWith(trim(line),"*/")) {
				commentBlock = false;
				int a;
			} else if (commentBlock) {
				int a;
			} else {
				ruleLength += 1;
			}
		}
	}
	
	iprintln(ruleLength);	
}

public void numberOfRuleBlocks() {
	M3 stylesheet = createM3FromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	iprintln(size(ruleSets(stylesheet)));
}

// @TODO / IS THIS EVEN POSSIBLE? CREATING EQUIVALENCE CLASSES IS NOT DEFINE...
public void entropyMetrics() {
	
}

public void numberOfExtendedRuleBlocks() {
	M3 stylesheet = createM3FromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	iprintln(size(ruleSets(stylesheet)));
}

public void numberOfAttributesDefinedPerRuleBlock() {
	M3 stylesheet = createM3FromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	int d = size(declarations(stylesheet));
	int r = size(ruleSets(stylesheet));
	
	iprintln(toReal(d)/toReal(r));
}

public void numberOfCohesiveRuleBlocks() {
	M3 stylesheet = createM3FromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	int cohesiveRuleBlocks = 0;
	
	for (rule <- ruleSets(stylesheet)) {
		if (size({a | <e,a> <- stylesheet@containment, e == rule, isDeclaration(a)}) == 1) {
			cohesiveRuleBlocks += 1;
		}
	}
	
	iprintln(cohesiveRuleBlocks);
}

// From the paper: CSS Code Quality: A Metric for Abstractness

public void universality() {
	Statement stylesheet = createAstFromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	map[str,int] values = ("all":0, "elements":0);
	
	visit (stylesheet) {
		case class(str name): {
			values["all"] += 1;
		}
		case id(str name): {
			values["all"] += 1;
		}
    	case domElement(str name): {
    		values["all"] += 1;
    		values["elements"] += 1;
    	}
	};
	
	real uni = toReal(values["all"]) / toReal(values["elements"]); 
	
	iprintln(uni);
}

// From the paper: Discovering Refactoring Opportunities in Cascading Style Sheets

public void type1Clone() {
	Statement stylesheet = createAstFromFile(|home:///Documents/workspace/testCSS/sandbox/amazon.css|);
	
	list[Statement] rules = [];
	rel[Statement,Statement] clones = {};
	
	visit (stylesheet) {
		case ruleSet(list[Type] selector, list[Declaration] declarations): {
			if (ruleSet(selector, declarations) notin rules) {
				rules = rules + ruleSet(selector, declarations);
			} else {
				clones += <ruleSet(selector, declarations),ruleSet(selector, declarations)>;
			}
		}
	};
	
	iprintln(clones);
}