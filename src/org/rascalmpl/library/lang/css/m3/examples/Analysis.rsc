module lang::css::m3::examples::Analysis

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

Statement stylesheetAST = createAstFromFile(|home:///workspace/testCSS/sandbox/amazon.css|);
M3 stylesheetM3 = createM3FromFile(|home:///workspace/testCSS/sandbox/amazon.css|);

public void basicAnalysis() {
	
	loc style = getOneFrom(stylesheets(stylesheetM3));
	
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
	map[str,int] values = ("classes":0, "ids":0, "elements":0);
	
	visit (stylesheetAST) {
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
	map[str,int] values = ("selectors":0, "total":0, "min":1, "max":0, "average":0);
	
	visit (stylesheetAST) {
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
	lrel[str,int] values = [];
	
	visit (stylesheetAST) {
		case declaration(str property, list[Type] declarationValues): {
			if (size(values[property]) == 0) {
				values += [<property,1>];
			} else {
				int val = (values[property][0])+1;
				values -= [<property,values[property][0]>];
				values += [<property,val>];
			}
		}
	};
	
	iprintln(sort(values));
}

public void declarationAnalysis2() {
	lrel[str,list[Declaration]] values = [];
	
	visit (stylesheetAST) {
		case declaration(str property, list[Type] declarationValues): {
			values += <property,[declaration(property, declarationValues)]>;
		}
	};
	
	for (val <- sort(values)) {	
		visit (val[1]) {
			case \audio(num aud, str unit):  { iprintln("<val[0]>: <ppx(Type::audio(aud,unit))>"); }
		    case \angle(num angle, str unit): { iprintln("<val[0]>: <ppx(Type::angle(angle,unit))>"); }
		    case \color(int red, int green, int blue, num alpha): { iprintln("<val[0]>: <ppx(Type::color(red,green,blue,alpha))>"); }
		    case \expression(str expression): { iprintln("<val[0]>: <ppx(Type::expression(expression))>"); }
		    case \calc(str expression): { iprintln("<val[0]>: <ppx(Type::calc(expression))>"); }
		    case \frequency(num freq, str unit): { iprintln("<val[0]>: <ppx(Type::frequency(freq,unit))>"); }
		    case \function(str func, list[Type] exp): { iprintln("<val[0]>: <ppx(Type::function(func,exp))>"); }
		    case \ident(str ident): { iprintln("<val[0]>: <ppx(Type::ident(ident))>"); }
		    case \integer(int a): { iprintln("<val[0]>: <ppx(Type::integer(a))>"); }
		    case \length(num \len, str unit): { iprintln("<val[0]>: <ppx(Type::length(\len,unit))>"); }
		    case \percent(num \perc): { iprintln("<val[0]>: <ppx(Type::percent(\perc))>"); }
		    case \list(list[Type] pair): { iprintln("<val[0]>: <ppx(Type::\list(pair))>"); }
		    case \number(num number): { iprintln("<val[0]>: <ppx(Type::number(\number))>"); }
		    case \resolution(num \res, str unit): { iprintln("<val[0]>: <ppx(Type::resolution(\res,unit))>"); }
		    case \string(str \string): { iprintln("<val[0]>: <ppx(Type::string(\string))>"); }
		    case \time(num \time, str unit): { iprintln("<val[0]>: <ppx(Type::time(\time,unit))>"); }
		    case \uri(str \uri): { iprintln("<val[0]>: <ppx(Type::uri(\uri))>"); }
		};
	}
}

public void modifierAnalysis() {
	visit (stylesheetAST) {
		case declaration(str property, list[Type] declarationValues): {
			iprintln(GetTraversalContextNodes());
			iprintln("KAK");
		}
	};
		
}

/**
 * From the paper: Complexity Metrics for Cascading Style Sheets
 */
public void ruleLength() {	
	set[loc] rules = ruleSets(stylesheetM3);
	
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
	iprintln(size(ruleSets(stylesheetM3)));
}

// @TODO / IS THIS EVEN POSSIBLE? CREATING EQUIVALENCE CLASSES IS NOT DEFINE...
public void entropyMetrics() {
	
}

public void numberOfExtendedRuleBlocks() {	
	iprintln(size(ruleSets(stylesheetM3)));
}

public void numberOfAttributesDefinedPerRuleBlock() {	
	iprintln(toReal(size(declarations(stylesheetM3)))/toReal(size(ruleSets(stylesheetM3))));
}

public void numberOfCohesiveRuleBlocks() {	
	iprintln(size([rule | rule <- ruleSets(stylesheetM3), size({a | <e,a> <- stylesheetM3@containment, e == rule, isDeclaration(a)}) == 1]));
}

// From the paper: CSS Code Quality: A Metric for Abstractness

public void universality() {	
	map[str,int] values = ("all":0, "elements":0);
	
	visit (stylesheetAST) {
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
	list[Statement] rules = [];
	rel[Statement,Statement] clones = {};
	
	visit (stylesheetM3) {
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

// From the thesis: The A-B*-A Pattern of Undoing Style in Cascading Style Sheets

public void filterUndoingStyles(Statement rules) {
	list[Statement] possibleUndoingStyles;
	list[Statement] undoingStyles;
	
	// Maybe too much work for now...
}