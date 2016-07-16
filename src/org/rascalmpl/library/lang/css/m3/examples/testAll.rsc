module lang::css::m3::examples::testAll

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
		|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/360.cn.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/alieexpress.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/amazon.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/apple.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/baidu.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/bing.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/blogger.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/chinadaily.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/diply.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/ebay.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/facebook.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/fc2.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/gmw.cn.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/google.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/hao123.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/imdb.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/imgur.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/instagram.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/kat.cr.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/linkedin.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/live.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/mail.ru.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/microsoft.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/msn.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/naver.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/netflix.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/office.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/ok.ru.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/onclickads.net.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/paypal.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/pinterest.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/pornhub.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/qq.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/reddit.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/sina.com.cn.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/sohu.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/stackoverflow.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/taobao.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/tmall.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/tumblr.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/twitter.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/vk.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/weibo.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/whatsapp.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/wikipedia.org.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/wordpress.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/xvideos.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/yahoo.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/yandex.ru.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/youtube.com.css|
	 //|home:///Documents/workspace/Rascal/rascal/testCSS/examples/pseudo.css|
	];
	
	for (d <- dirs) {
		stylesheetAST = createAstFromFile(d);

		//println("<d.file>");
		
		map[str,int] values = selectorAnalysis(); 
		
		//("classes":0, "ids":0, "elements":0, "attr":0, "pseudoclass":0, "pseudoelem":0);
		
		println("<d.file> ; <values["classes"]> ; <values["ids"]> ; <values["elements"]> ; <values["attr"]> ; <values["pseudoclass"]> ; <values["pseudoelem"]>");
		
		//writeFile(|home:///Documents/workspace/Rascal/rascal/testCSS/specificity/<d.file>.csv|, specificity(stylesheetAST));
	}
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

public int vendorPrefixFallback() {
	list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
	str originalProperty = "";
	bool fallback = true;
	
	int total = 0;
	
	bottom-up visit (stylesheetAST) {
		case rs:ruleSet(list[Type] selector, list[Declaration] declarations): {
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

public map[str,int] selectorAnalysis() {
	map[str,int] values = ("classes":0, "ids":0, "elements":0, "attr":0, "pseudoclass":0, "pseudoelem":0);
	
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
    	case attributeSelector(str attribute, str op, str attrval): {
    		values["attr"] += 1;
    	}
    	case attributeSelector(str attribute): {
    		values["attr"] += 1;
    	}
    	case pseudoClass(str class): {
    		values["pseudoclass"] += 1;
    	}
    	case pseudoElement(str elem): {
    		values["pseudoelem"] += 1;
    	}
	};
	
	return values;
	
}