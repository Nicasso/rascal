module lang::css::m3::examples::Stylestats

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

/**
 * From github.com/t32k/stylestats
 */
 
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
	];
	
	for (d <- dirs) {
		stylesheetAST = createAstFromFile(d);

		iprintln("<d> & <simplicity()> & <averageIdentifier()> & <averageCohesion()>"); 
	}
}

Statement stylesheetAST;

public real simplicity() {	
	return toReal(
		toReal(size([1 | /rs:ruleSet(list[Type] selector, list[Declaration] declarations) := stylesheetAST]))
	/
		(
			toReal(size([1 | /rs:selector(list[Type] simpleSelectors) := stylesheetAST]))+
			toReal(size([1 | /rs:selector(list[Type] simpleSelectors, str combinator) := stylesheetAST]))
		)
	);
}

public real averageIdentifier() {
	return toReal(
		(
			toReal(size([1 | /rs:class(str name) := stylesheetAST]))+
			toReal(size([1 | /rs:id(str name) := stylesheetAST]))+
			toReal(size([1 | /rs:domElement(str name) := stylesheetAST]))
		)
	/
		(
			toReal(size([1 | /rs:selector(list[Type] simpleSelectors) := stylesheetAST]))+
			toReal(size([1 | /rs:selector(list[Type] simpleSelectors, str combinator) := stylesheetAST]))
		)
	);
}

public real averageCohesion() {
	return toReal(
	(
	toReal(size([1 | /rs:declaration(str property, list[Type] values) := stylesheetAST]))
	)
	/
	toReal(size([1 | /rs:ruleSet(list[Type] selector, list[Declaration] declarations) := stylesheetAST]))
	);
}