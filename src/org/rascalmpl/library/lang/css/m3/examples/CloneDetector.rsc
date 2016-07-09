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

public int massThreshold = 5;
public real similarityThreshold;
loc currentProject = |home:///Documents/workspace/Rascal/rascal/testCSS/examples/a|;
int cloneType;
map[node, lrel[node, loc]] buckets = ();
map[node, lrel[tuple[node, loc] L, tuple[node, loc] R]] cloneClasses = ();
list[node] subCloneClasses = [];

list[loc] dirs = [
		//|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/360.cn.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/alieexpress.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/amazon.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/apple.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/baidu.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/bing.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/blogger.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/chinadaily.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/diply.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/ebay.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/facebook.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/fc2.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/gmw.cn.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/google.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/hao123.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/imdb.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/imgur.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/instagram.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/kat.cr.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/linkedin.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/live.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/mail.ru.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/microsoft.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/msn.com.css|,
	    //|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/naver.com.css|
	    
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
	
public void go() {
	for (d <- dirs) {
		currentProject = d;
		//iprintln("Type 1");
		detectClones(1);
		////iprintln("Type 2");
		detectClones(2);
		////iprintln("Type 3");
		detectClones(3);
	}
}	

public void detectClones(int cloneT) {
	cloneType = cloneT;
	
	//iprintln("Attack of the clones!");
	//println(printTime(now(), "HH:mm:ss"));
	
	buckets = ();
	cloneClasses = ();
	subCloneClasses = [];
	
	Declaration stylesheetAst = createAstFromFile(currentProject);

	similarityThreshold = if (cloneType <= 2) 1.0; else 0.75;
	
	// Add all the subtrees with a mass higher than the massThreshold into a bucket.
	// Depening on the clone type we want to find, we normalize the subtrees.
	chooseSubtrees(stylesheetAst);
	
	//println("Done with indexing the subtrees into buckets.");
	//println(printTime(now(), "HH:mm:ss"));
	
	for (bucket <- buckets, size(buckets[bucket]) >= 2) {
		lrel[tuple[node,loc] L, tuple[node,loc] R] complementBucket = buckets[bucket] * buckets[bucket];
		complementBucket = [p | p <- complementBucket, p.L != p.R];
		complementBucket = [<L, R> | [*_, <L,R>, *post] := complementBucket, <R, L> notin post];
		createCloneClasses(complementBucket);
	}
	
	//println("Done with finding clones from buckets and created cloneClasses.");
	//println(printTime(now(), "HH:mm:ss"));
	
	// Loop through all the clone classes and remove all smaller subclones.
	for (currentClass <- cloneClasses) {
		//println(size(cloneClasses[currentClass]));
		checkIfInnerClone(currentClass);
	}
	
	//println("Indexed all thesmaller subclones");
	//println(printTime(now(), "HH:mm:ss"));
	
	// Remove the subclones one by one from the cloneClasses.
	for (subCloneClas <- subCloneClasses) {
		cloneClasses = delete(cloneClasses, subCloneClas);
	}

	//println("Removed all subclones from the cloneClasses");
	//println(printTime(now(), "HH:mm:ss"));
	
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

// Normalize all variable types of the leaves in a tree.
public node normalizeNodeDec(node ast) {
	return visit (ast) {
		case n:ruleSet(list[Expression] selector, list[Statement] Statements) => normalizedRuleset(n, Statements)
		//case n:class(str name) => normalizedSelector(n) 
  //  	case n:id(str name) => normalizedSelector(n)
  //  	case n:domElement(str name) => normalizedSelector(n)
	};
}

public Declaration normalizedRuleset(Declaration s, list[Statement] Statements) {
	Declaration rs = ruleSet([], Statements);
	rs@src = s@src;
	return rs;
}

public Type normalizedSelector(Type n) {
	Type sel = class("lol");
	sel@src = n@src;
	return sel;
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
					}				}
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
		bool first = true;
		for (uniqueClone <- clonePairsPerClass) {
			if (!first) {
				lines += size(readFileLines(uniqueClone));
			} else {
				first = false;
			}
			//iprint(uniqueClone);
			//println(" <size(readFileLines(uniqueClone))>");
		}
		//iprintln("--------------------------------------------------");
	}
	
	//iprintln("Site: <currentProject.file> - Clone type <cloneType> - Clone pair count: <counting> - Total cloned lines: <lines>");
	iprintln("<currentProject.file> ; <cloneType> ; <lines>");
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