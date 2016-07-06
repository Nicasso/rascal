module lang::css::m3::examples::ParserTest

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
import DateTime;

Statement stylesheetAST; 
 
public void go() {

	list[loc] dirs = [
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/360.cn.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/alieexpress.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/amazon.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/apple.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/baidu.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/bing.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/blogger.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/chinadaily.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/diply.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/ebay.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/facebook.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/fc2.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/gmw.cn.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/google.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/hao123.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/imdb.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/imgur.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/instagram.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/kat.cr.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/linkedin.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/live.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/mail.ru.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/microsoft.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/msn.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/naver.com.css|,
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
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/taobao.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/tmall.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/tumblr.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/twitter.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/vk.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/weibo.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/whatsapp.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/wikipedia.org.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/wordpress.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/xvideos.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/yahoo.com.css|,
	    //|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/yandex.ru.css|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/youtube.com.css|
	];
	
	for (d <- dirs) {
		stylesheetAST = createAstFromFile(d);
		
		//println("<d.file> <[size(ss@messages) | /ss:stylesheet(str name, list[Statement] rules) := stylesheetAST, size(ss@messages) > 0]>");
				
		visit(stylesheetAST) {
			case ss:stylesheet(str name, list[Statement] rules): {
				for(m <- ss@messages) {
					iprintln(m);
				}				
			}
		}
		
		
	}
}