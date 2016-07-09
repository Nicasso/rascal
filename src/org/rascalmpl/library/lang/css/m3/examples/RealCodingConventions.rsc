module lang::css::m3::examples::RealCodingConventions

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

// Fixed
Declaration stylesheetAST;

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
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/netflix.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/office.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/ok.ru.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/onclickads.net.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/paypal.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/pinterest.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/pornhub.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/qq.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/reddit.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/sina.com.cn.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/sohu.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/stackoverflow.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/taobao.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/tmall.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/tumblr.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/twitter.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/vk.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/weibo.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/whatsapp.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/wikipedia.org.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/wordpress.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/xvideos.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/yahoo.com.css|,
	 //   |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/yandex.ru.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/youtube.com.css|
	    |home:///workspace/Rascal/rascal/testCSS/examples/bibtex.css|
	];
	
	for (d <- dirs) {
	
		iprintln(createAstFromFile(d));
	
		//stylesheetAST = createAstFromFile(d);
		//println(d.file);
		//
		//checkConventions(); 
	}
}

public void checkConventions() {
	//int a = shortHexValues();
	//println("<a>");
	//int b = shorthandMarginPadding();
	//println("<b>");
	//int c = noEmptyRules();
	//println("<c>");
	//int d = avoidIds();
	//println("<d>");
	int e = vendorPrefixFallback();
	println("<e>");
	//int f = useEmInsteadOfPix();
	//println("<f>");
	//int g = duplicateProperties();
	//println("<g>");
	//int h = disallowImport();
	//println("<h>");
	//int i = disallowImportant();
	//println("<i>");
	//int j = qualifyingNameWithTypeSelectors();
	//println("<j>");
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

public int shorthandMarginPadding() {
	int total = 0;
	visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Statement] declarations): {
			list[str] margin = ["margin-top", "margin-right", "margin-bottom", "margin-left"];
			for (d <- declarations, d[0] in margin) {
				margin -= d[0];
				if (size(margin) == 0) {
					//print("Margin shorthand should be used at: <rs@src>");
					total += 1;
				}
			}
			
			list[str] padding = ["padding-top", "padding-right", "padding-bottom", "padding-left"];
			for (d <- declarations, d[0] in padding) {
				padding -= d[0];
				if (size(padding) == 0) {
					//print("Margin shorthand should be used at: <rs@src>");
					total += 1;
				}
			}
		}
	};
	return total;
}

public void shorthandMargin(Declaration stylesheetAST) {
	visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Statement] declarations): {
			list[str] margin = ["margin-top", "margin-right", "margin-bottom", "margin-left"];
			for (d <- declarations, d[0] in margin) {
				margin -= d[0];
				if (size(margin) == 0) {
					print("Margin shorthand should be used at: <rs@src>");
				}
			}
		}
	};
}

public int noEmptyRules() {
	int total = 0;
	visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Statement] declarations): {
			if (size(declarations) == 0) {
				total += 1;
			}
		}
	};
	return total;
}

public int avoidIds() {
	int total = 0;
	visit (stylesheetAST) {
		case i:id(str name): {
			total += 1;
		}
	};
	return total;
}

public int vendorPrefixFallback() {
	list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
	set[str] required = {};
	int total = 0;
	top-down visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Statement] declarations): {
			if (size(required) > 0) {
				total += size(required);
				required = {};
			}
		}
		case d:declaration(str property, list[Type] values): {
			if (property in required) {
				required -= property;
			} else {
				for (pre <- prefixes, startsWith(property, pre)) {
					required += replaceFirst(property, pre, "");
					break;
				}
			}
		}
	};
	return total;
}

public void vendorPrefixFallback2() {
	list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
	set[str] required = {};
	top-down visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Statement] declarations): {
			if (size(required) > 0) {
				print("One or more vendor specific declarations are used without a fallback of the standard property at: <rs@src>");
				required = {};
			}
		}
		case d:declaration(str property, list[Type] values): {
			if (property in required) {
				required -= property;
			} else {
				for (pre <- prefixes, startsWith(property, pre)) {
					required += replaceFirst(property, pre, "");
					break;
				}
			}
		}
	};
}

public int useEmInsteadOfPix() {
	bool fontRelatedProperty = false;
	Statement currentDeclaration;
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

public int duplicateProperties() {
	int total = 0;
	list[str] unique = [];
	bottom-up visit (stylesheetAST) {
		case rs:ruleSet(list[Expression] selector, list[Statement] declarations): {
			unique = [];
		}
		case d:declaration(str property, list[Type] values): {
			if (property notin unique) {
				unique += property;
			} else {
				total += 1;
			}
		}
	};
	return total;
}

public int disallowImport() {
	int total = 0;
	
	visit (stylesheetAST) {
		case ruleImport(str uri): {
			total += 1;
		}
		case ruleImport(str uri, list[Type] mediaQueries): {
			total += 1;
		}
	};
	
	return total;
}

public int disallowImportant() {
	int total = 0;
	visit (stylesheetAST) {
		case d:declaration(str property, list[Type] values): {
			if (d@modifier?) {
				if (d@modifier == "important") {
					total += 1;
				}
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