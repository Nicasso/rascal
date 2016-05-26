module lang::css::m3::examples::CodingConventions

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

Statement stylesheetAST = createAstFromFile(|home:///workspace/Rascal/rascal/testCSS/examples/conventions.css|);
M3 stylesheetM3 = createM3FromFile(|home:///workspace/Rascal/rascal/testCSS/examples/conventions.css|);

public void checkConventions() {
	semiColon();
	urlQuotes();
	shortHexValues();
	shorthandMargin();
	zeroUnits();
	leadingZeros();
	qualifyingNameWithTypeSelectors();
	useEmInsteadOfPix();
	avoidZindex();
	compatibleVendorPrefix();
	avoidIds();
	noUppercaseInSelectors();
	noUppercaseInValues();
	singleQuotesInCharset();
	singleQuotesInAttributeSelector();
	declarationColonSpace();
	spaceAfterLastSelector();
	oneSelectorPerLine();
	noEmptyRules();
	vendorPrefixFallback();
	noTrailingSpaces();
}

public void semiColon() {
	for (d <- declarations(stylesheetM3)) {
		for(r <- stylesheetM3@declarations, r[0] == d) {
			loc a = r[1];
			a.length = a.length + 1;
			str line = trim(readFileLines(a)[size(readFileLines(a))-1]);
			if (stringChar(charAt(line, size(line)-1)) != ";") {
				println("No semicolon used at: <d>");
			}
		}
	}
}

public void urlQuotes() {
	visit (stylesheetAST) {
		case u:uri(str uri): {
			if (contains(uri, "\"") == true) {
				println("Quotes used in URL declaration: <d>");
			}
		}
	}
}

public void shortHexValues() {
	visit (stylesheetAST) {
		case lal:color(int red, int green, int blue, num alpha): {
			str color = trim(readFileLines(lal@src)[0]);
			if (stringChar(charAt(color, 0)) == "#") {
				str hex = substring(color, 1, size(color));
				bool same = true;
				for(c <- chars(hex)) {
					if (c != chars(hex)[0]) {
						same = false;
					}
				}
				if (same && size(color) == 7) {
					println("Long hex value used at: <lal@src>");
				}
			}
		}
	}
}

public void marginShorthand() {
	newAST = visit (stylesheetAST) {
		case ruleSet(list[Type] selector, list[Declaration] declarations): {
 			//checkForMarginShorthands(declarations);
 			int a;
	 	}
	};
}

public void shorthandMargin() {
	list[str] margin;
	
	visit (stylesheetAST) {
		case rs:ruleSet(list[Type] selector, list[Declaration] declarations): {
			margin = ["margin-top", "margin-right", "margin-bottom", "margin-left"];
			for (d <- declarations) {
				if (d[0] in margin) {
					margin -= d[0];
					if (size(margin) == 0) {
						print("Margin shorthand should be used at: <rs@src>");
					}
				}
			}
		}
	};
}

public void zeroUnits() {	
	visit (stylesheetAST) {
		case \n:audio(num aud, str unit):  { 
			if (aud == 0) {
				println("Unit used after zero value at: <n@src>");
			}
		}
	    case \n:angle(num angle, str unit): {
    		if (angle == 0) {
				println("Unit used after zero value at: <n@src>");
			} 
	    }
	    case \n:frequency(num freq, str unit): {
	    	if (freq == 0) {
				println("Unit used after zero value at: <n@src>");
			}
	    }
	    case \n:length(num \len, str unit): {
	    	if (len == 0) {
				println("Unit used after zero value at: <n@src>");
			}  
	    }
	    case \n:percent(num \perc): {
	    	if (perc == 0) {
				println("Unit used after zero value at: <n@src>");
			} 
	    }
	    case \n:resolution(num \res, str unit): {
	    	if (res == 0) {
				println("Unit used after zero value at: <n@src>");
			}
	    }
	    case \n:time(num \time, str unit): {
	    	if (time == 0) {
				println("Unit used after zero value at: <n@src>");
			} 
	    }
	};
}

public void leadingZeros() {	
	visit (stylesheetAST) {
		case \n:audio(num aud, str unit):  { 
			str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				println("No leading zero usedat: <n@src>");
			}
		}
	    case \n:angle(num angle, str unit): {
    		str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				println("No leading zero usedat: <n@src>");
			}
	    }
	    case \n:frequency(num freq, str unit): {
	    	str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				println("No leading zero usedat: <n@src>");
			}
	    }
	    case \n:length(num \len, str unit): {
	    	str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				println("No leading zero usedat: <n@src>");
			}
	    }
	    case \n:percent(num \perc): {
	    	str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				println("No leading zero usedat: <n@src>");
			}
	    }
	    case \n:resolution(num \res, str unit): {
	    	str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				println("No leading zero usedat: <n@src>");
			}
	    }
	    case \n:time(num \time, str unit): {
	    	str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				println("No leading zero usedat: <n@src>");
			}
	    }
	};
}

public void qualifyingNameWithTypeSelectors() {

	Expression currentSelector;
	bool typeSelector = false;
	bool check = false;

	top-down visit (stylesheetAST) {
		case s:selector(list[Type] simpleSelectors): {
			if (size(simpleSelectors) > 1) {
				currentSelector = s;
				check = true;
			} else {
				check = false;
				typeSelector = false;
			}
		}
		case s:selector(list[Type] simpleSelectors, str combinator): {
			if (size(simpleSelectors) > 1) {
				currentSelector = s;
				check = true;
			} else {
				check = false;
				typeSelector = false;
			}
		}
		case class(str name): {
			if (typeSelector && check) {
				println("Selector combines class names with type selector at: <currentSelector@src>");
			}	
			typeSelector = false;
		}
		case id(str name): {
			if (typeSelector && check) {
				println("Selector combines id names with type selector at: <currentSelector@src>");
			}
			typeSelector = false;
		}
		case domElement(str name): {
			typeSelector = true;
		}
	};
}

public void useEmInsteadOfPix() {
	bool fontRelatedProperty = false;
	Declaration currentDeclaration;
	
	top-down visit (stylesheetAST) {
		case d:declaration(str property, list[Type] values): {
			if (property == "font"||  property == "font-size") {
				currentDeclaration = d;
				fontRelatedProperty = true;
			} else {
				fontRelatedProperty = false;
			}
		}
	    case \n:length(num \len, str unit): {
	    	if (fontRelatedProperty && unit == "px") {
	    		println("px unit used instead of em at: <currentDeclaration@src>");
	    	}
	    }
	};
}

public void avoidZindex() {
	visit (stylesheetAST) {
		case d:declaration(str property, list[Type] values): {
			if (property == "z-index") {
				println("z-index used at: <d@src>");
			}
		}
	};
}

public void compatibleVendorPrefix() {
	list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
	list[str] props = ["animation","animation-delay"];
	
	list[Declaration] currentDeclarations;	
	
	top-down visit (stylesheetAST) {
		case rs:ruleSet(list[Type] selector, list[Declaration] declarations): {
			currentDeclarations = declarations;
		}
		case d:declaration(str property, list[Type] values): {
			for (prop <- props) {
				if (property == prop) {
					for (pre <- prefixes) {
						str ven = "<pre><property>";
						if (ven notin currentDeclarations) {
							println("<ven> fallback missing for property at: <d@src>");
						}
					}
				}				
			}
		}
	}	
}

public void avoidIds() {
	visit (stylesheetAST) {
		case i:id(str name): {
			println("ID selector used at: <i@src>");
		}
	};
}

public void noUppercaseInSelectors() {
	visit (stylesheetAST) {
		case i:id(str name): {
			if (name != toLowerCase(name)) {
				println("Uppercase characters used in id selector at: <i@src>");
			}
		}
		case c:class(str name): {
			if (name != toLowerCase(name)) {
				println("Uppercase characters used in id selector at: <c@src>");
			}
		}
	};
}

public void noUppercaseInValues() {
	visit (stylesheetAST) {
		case i:ident(str name): {
			if (name != toLowerCase(name)) {
				println("Uppercase characters used in value at: <i@src>");
			}
		}
	};
}

public void singleQuotesInCharset() {
	visit (stylesheetAST) {
		case rc: ruleCharset(str name): {
			if (contains(name, "\'") == false) {
				println("No single quotes used  for the charset rule at: <rc@src>");
			}
		}
	}
}

public void singleQuotesInAttributeSelector() {
	visit (stylesheetAST) {
		case as:attributeSelector(str attribute, str op, str \value): {
			if (contains(\value, "\'") == false) {
				println("No single quotes used  for the attribute selector at: <as@src>");
			}
		}
		case as:attributeSelector(str attribute): {
			if (contains(\value, "\'") == false) {
				println("No single quotes used  for the attribute selector at: <as@src>");
			}
		}
	}
}

public void declarationColonSpace() {
	visit (stylesheetAST) {
		case d:declaration(str property, list[Type] values): {
			str line = trim(readFileLines(d@src)[0]);
			if (!contains(line, ": ")) {
				println("No space after the colon at: <d@src>");
			}
		}
	};
}

public void spaceAfterLastSelector() {
	visit (stylesheetAST) {
		case rs:ruleSet(list[Type] selector, list[Declaration] declarations): {
			bool found = false;
			for (l <- readFileLines(rs@src)) {
				if (contains(l, " {")) {
					found = true;
				}
			}
			if (!found) {
				println("No space between the last selector and the { present at: <rs@src>");
			}
		}
	};
}

public void oneSelectorPerLine() {
	list[int] selectorLines = [];
	visit (stylesheetAST) {
		case s:combinedSelector(list[Expression] selectors): {
			if (s@src.begin.line notin selectorLines) {
				selectorLines += s@src.begin.line;
			} else {
				println("Selectors are placed on the same line at: <s@src>");
			}
		}
	};
}

public void noEmptyRules() {
	visit (stylesheetAST) {
		case rs:ruleSet(list[Type] selector, list[Declaration] declarations): {
			if (size(declarations) == 0) {
				println("Empty ruleset at: <rs@src>");
			}
		}
	};
}

public void vendorPrefixFallback() {
	list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
	
	str originalProperty = "";
	bool fallback = true;
	
	bottom-up visit (stylesheetAST) {
		case rs:ruleSet(list[Type] selector, list[Declaration] declarations): {
			if (fallback == false ) {
				println("The <originalProperty> property has not been provided as a fallback at: <rs@src>");
			}
			originalProperty = "";
			fallback = true;
		}
		case d:declaration(str property, list[Type] values): {
			for (pre <- prefixes) {
				if (contains(property, pre)) {
					fallback = false;
					originalProperty = replaceFirst(property, pre, "");
				} else if (property == originalProperty) {
					fallback = true;
				}
			}
		}
	};
}

public void noTrailingSpaces() {
	visit (stylesheetAST) {
		case ss:stylesheet(str name, list[Statement] rules): {
			bool found = false;
			for (l <- readFileLines(ss@src)) {
				if (contains(l, " \n")) {
					found = true;
				}
			}
			if (found) {
				println("Trailing spaces present in stylesheet: <ss@src>");
			}
		}
	};
}