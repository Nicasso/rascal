module lang::css::m3::examples::CodingConventions

import lang::css::m3::AST;
import lang::css::m3::Core;
import lang::css::m3::PrettyPrinter;

import IO;
import String;
import Relation;
import Set;
import Map;
import Node;
import List;
import util::Math;

Statement stylesheetAST;

public void metrics1() {

	list[loc] dirs = [
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/360.cn.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/alieexpress.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/amazon.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/apple.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/baidu.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/bing.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/blogger.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/chinadaily.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/diply.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/ebay.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/facebook.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/fc2.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/gmw.cn.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/google.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/hao123.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/imdb.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/imgur.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/instagram.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/kat.cr.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/linkedin.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/live.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/mail.ru.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/microsoft.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/msn.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/naver.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/netflix.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/office.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/ok.ru.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/onclickads.net.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/paypal.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/pinterest.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/pornhub.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/qq.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/reddit.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/sina.com.cn.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/sohu.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/stackoverflow.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/taobao.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/tmall.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/tumblr.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/twitter.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/vk.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/weibo.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/whatsapp.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/wikipedia.org.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/wordpress.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/xvideos.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/yahoo.com.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/yandex.ru.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/youtube.com.css|
	];
	
	for (d <- dirs) {
		//datetime begin = now();
		stylesheetAST = createAstFromFile(d);
		println(d.file);
		//datetime end = now();
		
		//diff = end-begin;
		//i//println("<d.file> <diff>");
		
		//i//println("<d> & <ruleLength()> & <numberOfRuleBlocks()> & <numberOfAttributesDefinedPerRuleBlock()> & <numberOfCohesiveRuleBlocks()>");
		
		checkConventions(); 
	}
}

public void checkConventions() {
	int a = semiColon();
	print("a");
	int b = urlQuotes();
	print("b");
	int c = shortHexValues();
	print("c");
	int d = shorthandMargin();
	print("d");
	int e = zeroUnits();
	print("e");
	int f = leadingZeros();
	print("f");
	int g = qualifyingNameWithTypeSelectors();
	print("g");
	int h = useEmInsteadOfPix();
	print("h");
	int i = avoidZindex();
	print("i");
	int j = compatibleVendorPrefix();
	print("j");
	int k = avoidIds();
	print("k");
	int l = noUppercaseInSelectors();
	print("l");
	int m = noUppercaseInValues();
	print("m");
	int n = singleQuotesInCharset();
	print("n");
	int \o = singleQuotesInAttributeSelector();
	print("o");
	int p = declarationColonSpace();
	print("p");
	int q = spaceAfterLastSelector();
	print("q");
	int r = oneSelectorPerLine();
	print("r");
	int s = noEmptyRules();
	print("s");
	int t = vendorPrefixFallback();
	print("t");
	int u = noTrailingSpaces();
	
	println("<a>,<b>,<c>,<d>,<e>,<f>,<g>,<h>,<i>,<j>,<k>,<l>,<m>,<n>,<\o>,<p>,<q>,<r>,<s>,<t>,<u>");
}

//public int semiColon() {
//	int total = 0;
//	for (d <- declarations(stylesheetM3)) {
//		for(r <- stylesheetM3@declarations, r[0] == d) {
//			loc a = r[1];
//			a.length = a.length + 1;
//			str line = trim(readFileLines(a)[size(readFileLines(a))-1]);
//			if (stringChar(charAt(line, size(line)-1)) != ";") {
//				//println("No semicolon used at: <d>");
//				total += 1;
//			}
//		}
//	}
//	return total;
//}

public int semiColon() {
	int total = 0;
	visit (stylesheetAST) {
		case d:declaration(str property, list[Type] values): {
			loc a = d@src;
			a.length = a.length + 1;
			str line = trim(readFileLines(a)[size(readFileLines(a))-1]);
			if (stringChar(charAt(line, size(line)-1)) != ";") {
				//println("No semicolon used at: <d>");
				total += 1;
			}
		}
	}
	return total;
}

//list[loc] urlQuotes() = [u@src | /u:uri(str uri) := stylesheetAST, contains(uri, "\"") || contains(uri, "\'")];

public int urlQuotes() {
	int total = 0;
	visit (stylesheetAST) {
		case u:uri(str uri): {
			if (contains(uri, "\"") == true) {
				//println("Quotes used in URL declaration: <u@src>");
				total += 1;
			}
		}
	}
	return total;
}

public int shortHexValues() {
	int total = 0;
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
					//println("Long hex value used at: <lal@src>");
					total += 1;
				}
			}
		}
	}
	return total;
}

public int shorthandMargin() {
	int total = 0;
	visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Declaration] declarations): {
			list[str] margin = ["margin-top", "margin-right", "margin-bottom", "margin-left"];
			for (d <- declarations, d[0] in margin) {
				margin -= d[0];
				if (size(margin) == 0) {
					//print("Margin shorthand should be used at: <rs@src>");
					total += 1;
				}
			}
		}
	};
	return total;
}

public int zeroUnits() {	
	int total = 0;
	visit (stylesheetAST) {
		case \n:audio(num aud, str unit):  { 
			if (aud == 0) {
				//println("Unit used after zero value at: <n@src>");
				total += 1;
			}
		}
	    case \n:angle(num angle, str unit): {
    		if (angle == 0) {
				//println("Unit used after zero value at: <n@src>");
				total += 1;
			} 
	    }
	    case \n:frequency(num freq, str unit): {
	    	if (freq == 0) {
				//println("Unit used after zero value at: <n@src>");
				total += 1;
			}
	    }
	    case \n:length(num \len, str unit): {
	    	if (len == 0) {
				//println("Unit used after zero value at: <n@src>");
				total += 1;
			}  
	    }
	    case \n:percent(num \perc): {
	    	if (perc == 0) {
				//println("Unit used after zero value at: <n@src>");
				total += 1;
			} 
	    }
	    case \n:resolution(num \res, str unit): {
	    	if (res == 0) {
				//println("Unit used after zero value at: <n@src>");
				total += 1;
			}
	    }
	    case \n:time(num \time, str unit): {
	    	if (time == 0) {
				//println("Unit used after zero value at: <n@src>");
				total += 1;
			} 
	    }
	};
	return total;
}

public int leadingZeros() {	
	int total = 0;
	visit (stylesheetAST) {
		case \n:audio(num aud, str unit):  { 
			str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				//println("No leading zero used at: <n@src>");
				total += 1;
			}
		}
	    case \n:angle(num angle, str unit): {
    		str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				//println("No leading zero used at: <n@src>");
				total += 1;
			}
	    }
	    case \n:frequency(num freq, str unit): {
	    	str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				//println("No leading zero used at: <n@src>");
				total += 1;
			}
	    }
	    case \n:length(num \len, str unit): {
	    	str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				//println("No leading zero used at: <n@src>");
				total += 1;
			}
	    }
	    case \n:percent(num \perc): {
	    	str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				//println("No leading zero used at: <n@src>");
				total += 1;
			}
	    }
	    case \n:resolution(num \res, str unit): {
	    	str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				//println("No leading zero used at: <n@src>");
				total += 1;
			}
	    }
	    case \n:time(num \time, str unit): {
	    	str val = trim(readFileLines(n@src)[0]);
	    	if (stringChar(charAt(val, 0)) == ".") {
				//println("No leading zero used at: <n@src>");
				total += 1;
			}
	    }
	};
	return total;
}

public int qualifyingNameWithTypeSelectors() {

	Expression currentSelector;
	bool typeSelector = false;
	bool check = false;
	int total = 0;

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
				//println("Selector combines class names with type selector at: <currentSelector@src>");
				total += 1;
			}	
			typeSelector = false;
		}
		case id(str name): {
			if (typeSelector && check) {
				//println("Selector combines id names with type selector at: <currentSelector@src>");
				total += 1;
			}
			typeSelector = false;
		}
		case domElement(str name): {
			typeSelector = true;
		}
	};
	
	return total;
}

public int useEmInsteadOfPix() {
	bool fontRelatedProperty = false;
	Declaration currentDeclaration;
	int total = 0;
	
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
	    		//println("px unit used instead of em at: <currentDeclaration@src>");
	    		total += 1;
	    	}
	    }
	};
	return total;
}

public int avoidZindex() {
	int total = 0;
	visit (stylesheetAST) {
		case d:declaration(str property, list[Type] values): {
			if (property == "z-index") {
				//println("z-index used at: <d@src>");
				total += 1;
			}
		}
	};
	return total;
}

public int compatibleVendorPrefix() {
	list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
	list[str] props = ["animation","animation-delay"];
	
	list[Declaration] currentDeclarations;	
	
	int total = 0;
	
	top-down visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Declaration] declarations): {
			currentDeclarations = declarations;
		}
		case d:declaration(str property, list[Type] values): {
			for (prop <- props) {
				if (property == prop) {
					for (pre <- prefixes) {
						str ven = "<pre><property>";
						if (ven notin currentDeclarations) {
							//println("<ven> fallback missing for property at: <d@src>");
							total += 1;
						}
					}
				}				
			}
		}
	}	
	return total;
}

public int avoidIds() {
	int total = 0;
	visit (stylesheetAST) {
		case i:id(str name): {
			//println("ID selector used at: <i@src>");
			total += 1;
		}
	};
	return total;
}

list[str] avoidIds2() = ["ID selector used at: <i@src>" | /i:id(str name) := stylesheetAST];

public int noUppercaseInSelectors() {
	int total = 0;
	visit (stylesheetAST) {
		case i:id(str name): {
			if (name != toLowerCase(name)) {
				//println("Uppercase characters used in id selector at: <i@src>");
				total += 1;
			}
		}
		case c:class(str name): {
			if (name != toLowerCase(name)) {
				//println("Uppercase characters used in id selector at: <c@src>");
				total += 1;
			}
		}
	};
	return total;
}

public int noUppercaseInValues() {
	int total = 0;
	visit (stylesheetAST) {
		case i:ident(str name): {
			if (name != toLowerCase(name)) {
				//println("Uppercase characters used in value at: <i@src>");
				total += 1;
			}
		}
	};
	return total;
}

public int singleQuotesInCharset() {
	int total = 0; 
	visit (stylesheetAST) {
		case rc: ruleCharset(str name): {
			if (contains(name, "\'") == false) {
				//println("No single quotes used  for the charset rule at: <rc@src>");
				total += 1;
			}
		}
	}
	return total;
}

public int singleQuotesInAttributeSelector() {
	int total = 0;
	visit (stylesheetAST) {
		case as:attributeSelector(str attribute, str op, str \value): {
			if (contains(\value, "\'") == false) {
				//println("No single quotes used  for the attribute selector at: <as@src>");
				total += 1;
			}
		}
	}
	return total;
}

public int declarationColonSpace() {
	int total = 0;
	visit (stylesheetAST) {
		case d:declaration(str property, list[Type] values): {
			str line = trim(readFileLines(d@src)[0]);
			if (!contains(line, ": ")) {
				//println("No space after the colon at: <d@src>");
				total += 1;
			}
		}
	};
	return total;
}

public int spaceAfterLastSelector() {
	int total = 0;
	visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Declaration] declarations): {
			bool found = false;
			for (l <- readFileLines(rs@src)) {
				if (contains(l, " {")) {
					found = true;
				}
			}
			if (!found) {
				//println("No space between the last selector and the { present at: <rs@src>");
				total += 1;
			}
		}
	};
	return total;
}

public int oneSelectorPerLine() {
	int total = 0;
	list[int] selectorLines = [];
	visit (stylesheetAST) {
		case s:combinedSelector(list[Expression] selectors): {
			if (s@src.begin.line notin selectorLines) {
				selectorLines += s@src.begin.line;
			} else {
				//println("Selectors are placed on the same line at: <s@src>");
				total += 1;
			}
		}
	};
	return total;
}

public int noEmptyRules() {
	int total = 0;
	visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Declaration] declarations): {
			if (size(declarations) == 0) {
				//println("Empty ruleset at: <rs@src>");
				total += 1;
			}
		}
	};
	return total;
}

public int vendorPrefixFallback() {
	list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
	str originalProperty = "";
	int total = 0;
	bool fallback = true;
	bottom-up visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Declaration] declarations): {
			if (fallback == false) {
				//println("The <originalProperty> property has not been provided as a fallback at: <rs@src>");
				total += 1;
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
	return total;
}

public int vendorPrefixFallback2() {
	list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
	set[str] required = {};
	int total = 0;
	bottom-up visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Declaration] declarations): {
			if (size(required) > 0) {
				for(r <- required) {
					//println("The <r> property has not been provided as a fallback at: <rs@src>");
					total += 1;
				}
			}
			required = {};
		}
		case d:declaration(str property, list[Type] values): {
			if (property in required) {
				required -= property;
			} else {
				for (pre <- prefixes, startsWith(property, pre)) {
					required += replaceFirst(property, pre, "");
				}
			}
		}
	};
	return total;
}

public int noTrailingSpaces() {
	int total = 0;
	visit (stylesheetAST) {
		case ss:stylesheet(str name, list[Statement] rules): {
			bool found = false;
			for (l <- readFileLines(ss@src)) {
				if (contains(l, " \n")) {
					found = true;
				}
			}
			if (found) {
				//println("Trailing spaces present in stylesheet: <ss@src>");
				total += 1;
			}
		}
	};
	return total;
}

//------------------------------------REFACTOR RELATED STUFF------------------------------------------

public Statement vendorPrefixFallbackRefactor() {
	return visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Declaration] declarations) => vendorPrefixFallbackRefactorHelper(selector, declarations)
	};
}

public Statement vendorPrefixFallbackRefactorHelper(list[Type] selector, list[Declaration] declarations) {
	list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
	set[tuple[str,list[Type]]] required = {};
	for (d:declaration(str property, list[Type] values) <- declarations) {
		if (<property,values> in required) {
			required -= <property, values>;
		} else {
			for (pre <- prefixes, startsWith(property, pre)) {
				required += <replaceFirst(property, pre, ""), values>;
			}
		}
	}
	if (size(required) > 0) {
		for (r <- required) {
			declarations += declaration(r[0], r[1]);
		}
	}
	return ruleSet(selector, declarations);
}