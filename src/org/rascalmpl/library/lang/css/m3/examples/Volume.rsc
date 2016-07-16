  module lang::css::m3::examples::Volume

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

public void calculateVolume() {

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
  
    //M3 stylesheetM3 = createM3FromFile(d);
  
    int \all = 0;
    int code = 0;
    int blank = 0;
    int comment = 0;
    
    //for (style <- stylesheets(stylesheetM3)) {
      \all = calculateAllLines(d);
      blank = calculateBlankLines(d);
    //}
    
    comment = calculateLinesOfComments(d);
    code = (\all - blank) - comment;
    
    //iprintln(stylesheetM3[0]);
    //iprintln("All lines: <\all>");
    //iprintln("Lines of code: <code>");
    //iprintln("Blank lines: <blank>");
    //iprintln("Lines of comments: <comment>");
    println("<d.file> ; <\all> ; <code> ; <blank> ; <comment>  ");
  }
}

int calculateAllLines(loc style) = size(readFileLines(style));  
int calculateLinesOfCode(loc style) = (calculateAllLines(style)-calculateBlankLines(style)-calculateLinesOfComments(stylesheet));  
int calculateLinesOfComments(loc style) {
	int comment = 0;
	bool commentBlock = false;
	for (line <- readFileLines(style)) {
		if (contains(line,"/*") && !contains(line,"*/")) { 
			commentBlock = true;
			comment += 1;
		} else if (commentBlock && contains(line,"*/")) { 
			commentBlock = false;
			comment += 1;
		} else if (contains(line,"/*") && contains(line,"*/") || commentBlock) {
			comment += 1;
		}
	}
	return comment; 
}
int calculateBlankLines(loc style) = size([1 | line <- readFileLines(style), trim(line) == ""]); 


public int calculateLinesOfComments2(M3 style) = sum([calculateAllLines(d[1]) | d <- style@documentation]);