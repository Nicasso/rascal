module lang::css::m3::examples::CloneDetector

import lang::css::m3::AST;
import lang::css::m3::Core;
import demo::common::Crawl;
import util::Math;
import IO;
import List;
import Map;
import Tuple;
import Type;
import Set;
import Prelude;
import String;
import Relation;
import ListRelation;
import util::Math;
import DateTime;
import Traversal;

public int massThreshold = 6;
public real similarityThreshold;
loc currentProject = |home:///Documents/workspace/Rascal/rascal/testCSS/examples/a|;
int cloneType;
map[node, lrel[node, loc]] buckets = ();
map[node, lrel[tuple[node, loc] L, tuple[node, loc] R]] cloneClasses = ();
list[node] subCloneClasses = [];

int type1Lines = 0;
int type2Lines = 0;
int type3Lines = 0;

list[loc] dirs = [
		//|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/360.cn.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/alieexpress.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/amazon.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/apple.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/baidu.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/bing.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/blogger.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/chinadaily.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/diply.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/ebay.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/facebook.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/fc2.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/gmw.cn.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/google.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/hao123.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/imdb.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/imgur.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/instagram.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/kat.cr.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/linkedin.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/live.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/mail.ru.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/microsoft.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/msn.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/naver.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/netflix.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/office.com.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/ok.ru.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/onclickads.net.css|,
	 //   |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/paypal.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/pinterest.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/pornhub.com.css|,
	    |home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/qq.com.css|
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/reddit.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/sina.com.cn.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/sohu.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/stackoverflow.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/taobao.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/tmall.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/tumblr.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/twitter.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/vk.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/weibo.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/whatsapp.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/wikipedia.org.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/wordpress.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/xvideos.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/yahoo.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/yandex.ru.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/youtube.com.css|
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/examples/clones.css|
	];
	
public void go() {
	for (d <- dirs) {
		type1Lines = 0;
		type2Lines = 0;
		type3Lines = 0;
		
		currentProject = d;
		
		iprintln("ALL: <size(readFileLines(d))>");
		
		iprintln("LOC: <calculateLinesOfCode(d)>");
		
		//detectClones(1);
		
		//detectClones(2);
		
		detectClones(3);
		
		iprintln("<currentProject.file> ; <type1Lines> ; <type2Lines> ; <type3Lines>");
	}
}	

public void detectClones(int cloneT) {
	cloneType = cloneT;
	
	buckets = ();
	cloneClasses = ();
	subCloneClasses = [];
	
	Declaration stylesheetAst = createAstFromFile(currentProject);

	similarityThreshold = if (cloneType <= 2) 1.0; else 0.80;
	
	chooseSubtrees(stylesheetAst);
	
	for (bucket <- buckets, size(buckets[bucket]) >= 2) {
		lrel[tuple[node,loc] L, tuple[node,loc] R] complementBucket = buckets[bucket] * buckets[bucket];
		complementBucket = [p | p <- complementBucket, p.L != p.R];
		complementBucket = [<L, R> | [*_, <L,R>, *post] := complementBucket, <R, L> notin post];
		createCloneClasses(complementBucket);
	}
	
	//for (currentClass <- cloneClasses) {
	//	//println(size(cloneClasses[currentClass]));
	//	checkIfInnerClone(currentClass);
	//}
//
	//for (subCloneClas <- subCloneClasses) {
	//	cloneClasses = delete(cloneClasses, subCloneClas);
	//}

	printCloneResults();
}

public void createCloneClasses(lrel[tuple[node,loc] L, tuple[node,loc] R] complementBucket) {
	for (treeRelation <- complementBucket, calculateSimilarity(treeRelation[0][0], 
		treeRelation[1][0]) >= similarityThreshold) {
			placeCloneInClass(treeRelation);
	}
}

public void placeCloneInClass(tuple[tuple[node,loc] L, tuple[node,loc] R] treeRelation) {
	if (cloneClasses[treeRelation[0][0]]?) {
		cloneClasses[treeRelation[0][0]] += treeRelation;
	} else {
		cloneClasses[treeRelation[0][0]] = [treeRelation];
	}
}

public void chooseSubtrees(Declaration stylesheetAsts) {
	if (cloneType == 1) {
		[addSubtreeToBucket(x, x) | /node x := stylesheetAsts, calculateMass(x) >= massThreshold, !(Type a := x)];
	} else {
		[addSubtreeToBucket(normalizeNodeDec(x), normalizeNodeDec(x)) | /node x := stylesheetAsts, calculateMass(x) >= massThreshold, !(Type a := x)];
	}
}

public node normalizeNodeDec(node ast) {
	return visit (ast) {
		case n:ruleSet(list[Expression] selector, list[Statement] declarations) => normalizedRuleset(n, declarations)
		case rm:ruleMedia(list[Type] mediaQueries, list[Declaration] ruleSets) => normalizedRuleMedia(rm, ruleSets)
		case ss:stylesheet(str name, list[Declaration] rules) => normalizedStylesheet(ss, rules)
		case cs:ruleCounterStyle(str name, list[Statement] declarations) => normalizedCounterStyle(cs, declarations)
		case im:ruleImport(str uri, list[Type] mediaQueries) => normalizedImport(im, uri)
		case rp:rulePage(str pseudo, list[Statement] declarations) => normalizedRulePage(rp, pseudo) 
	};
}

public Declaration normalizedRuleset(Declaration s, list[Statement] declarations) {
	Declaration rs = ruleSet([], declarations);
	rs@src = s@src;
	return rs;
}

public Declaration normalizedRuleMedia(Declaration s, list[Declaration] declarations) {
	Declaration rs = ruleMedia([], declarations);
	rs@src = s@src;
	return rs;
}

public Declaration normalizedStylesheet(Declaration s, list[Declaration] declarations) {
	Declaration rs = stylesheet("", declarations);
	rs@src = s@src;
	return rs;
}

public Declaration normalizedCounterStyle(Declaration s, list[Declaration] declarations) {
	Declaration rs = ruleCounterStyle("", declarations);
	rs@src = s@src;
	return rs;
}

public Declaration normalizedImport(Declaration s, str uri) {
	Declaration rs = ruleImport(uri, []);
	rs@src = s@src;
	return rs;
}

public Declaration normalizedRulePage(Declaration s, str pseudo) {
	Declaration rs = rulePage(pseudo, []);
	rs@src = s@src;
	return rs;
}

public void checkIfInnerClone(node currentCloneClass) {
	for (otherCloneClass <- cloneClasses) {
		bool allInnerClones = false;
		for (tuple[tuple[node n, loc l] L, tuple[node n, loc l] R] currentClonePair <- cloneClasses[currentCloneClass]) {
			if (size(cloneClasses[otherCloneClass]) == size(cloneClasses[currentCloneClass]) && currentCloneClass != otherCloneClass) {
				for (tuple[tuple[node n, loc l] L, tuple[node n, loc l] R] otherClonePair <- cloneClasses[otherCloneClass]) {
					if ((currentClonePair.L.l <= otherClonePair.L.l && currentClonePair.R.l <= otherClonePair.R.l) || (currentClonePair.R.l <= otherClonePair.L.l && currentClonePair.L.l <= otherClonePair.R.l)) {
						allInnerClones = true;
						break;
					} else {
						allInnerClones = false;
					}				
				}
			}
		}
		if (allInnerClones) {
			subCloneClasses += currentCloneClass;
		}
	}
}

public num calculateSimilarity(node t1, node t2) {
	//Similarity = 2 x S / (2 x S + L + R)
	list[node] tree1 = [x | /node x := t1];
	list[node] tree2 = [x | /node x := t2];
	
	num s = size(tree1 & tree2);
	num l = size(tree1 - tree2);
	num r = size(tree2 - tree1); 
	
	return (2 * s) / (2 * s + l + r);
}

public loc getLocationOfNode(node subTree) {
	loc result;
	switch(subTree) {
		case Statement n: result = n@src;
		case Expression n: result = n@src;
		case Declaration n: result = n@src;
		case Type n: result = n@src;
	}
	return result;
}

public node getBestKey(node key) {
	node bestKeyMatch;
	num highestSimilarity = 0;
	
	for (bucket <- buckets) {
		num currentSimilarity = calculateSimilarity(bucket, key);
		if (currentSimilarity >= similarityThreshold && currentSimilarity > highestSimilarity) {
			highestSimilarity = currentSimilarity;
			bestKeyMatch = bucket; 
		}
	}
	
	if (highestSimilarity > 0) {
		return bestKeyMatch;
	}
	
	return key;
}

public int addSubtreeToBucket(node key, node subTree) {
	loc location = getLocationOfNode(subTree);
	
	// Can go?
	if (location == currentProject) {
		return 0;
	}
	
	if (size(readFileLines(location)) < 3) {
		return 0;
	}
	
	if (cloneType == 3) {
		key = getBestKey(key);
	}
	
	if (buckets[key]?) {
		buckets[key] += <subTree, location>;
	} else {
		buckets[key] = [<subTree, location>];
	}
	
	return 1;
}

int calculateMass(node currentNode) = size([n | /node n := currentNode]);

public void printCloneResults() {
	int counting = 0;
	int lines = 0;
	
	set[int] uniqueLines = {};
	
	set[loc] clonePairsPerClass = {};
	//iprintln("All Type <cloneType> clones:");
	for (currentClass <- cloneClasses) {
		//iprintln("Total clone pairs in this class: <size(cloneClasses[currentClass])>");
		clonePairsPerClass = {};
		for (currentClone <- cloneClasses[currentClass]) {
			clonePairsPerClass += currentClone[0][1];
			clonePairsPerClass += currentClone[1][1];
			counting += 1;
		}

		for (uniqueClone <- clonePairsPerClass) {
			for (i <- [uniqueClone.begin.line .. (uniqueClone.end.line+1)]) {
				uniqueLines += i;
			}
		}
	}
	
	if (cloneType == 1) {
		type1Lines = size(uniqueLines);
	}
	if (cloneType == 2) {
		type2Lines = size(uniqueLines);
	}
	if (cloneType == 3) {
		type3Lines = size(uniqueLines);
	}
	
	//iprintln("Site: <currentProject.file> - Clone type <cloneType> - Clone pair count: <counting> - Total cloned lines: <lines>");
	//iprintln("<currentProject.file> ; <cloneType> ; <size(uniqueLines)>");
}

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

int calculateBlankLines(loc stylesheet) = size([0 | line <- readFileLines(stylesheet), trim(line) == ""]); 

int calculateLinesOfCode(loc style) = (size(readFileLines(style))-calculateBlankLines(style)-calculateLinesOfComments(style)); 

int calculateLinesOfComments(M3 stylesheetM3) = sum([0]+[size(readFileLines(d[1])) | d <- stylesheetM3@documentation]);