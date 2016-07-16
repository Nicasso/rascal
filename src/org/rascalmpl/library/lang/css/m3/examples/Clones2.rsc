module lang::css::m3::examples::Clones2

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

private int massThreshold = 5;
private real similarityThreshold;
private loc currentProject = |home:///workspace/Rascal/rascal/testCSS/examples/a|;
private int cloneType;
private map[node, lrel[node, loc]] buckets = ();
private map[node, lrel[tuple[node, loc] left, tuple[node, loc] right]] cloneClasses = ();
private list[node] subCloneClasses = [];

public void go() {
	currentProject = |home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/fc2.com.css|;
	detectClones(1);
	detectClones(2);
	detectClones(3);
}	

public void detectClones(int cloneT) {
	cloneType = cloneT;
	
	buckets = ();
	cloneClasses = ();
	subCloneClasses = [];
	similarityThreshold = if(cloneType <= 2) 1.0; else 0.75;
	Statement stylesheetAst = createAstFromFile(currentProject);
	
	chooseSubtreesByMass(stylesheetAst);
	
	for (bucket <- buckets, size(buckets[bucket]) >= 2) {
		lrel[tuple[node n,loc l] left, tuple[node n,loc l] right] complementBucket = buckets[bucket] * buckets[bucket];
		complementBucket = [p | p <- complementBucket, p.left != p.right];
		complementBucket = [<left, right> | [*_, <left,right>, *post] := complementBucket, <right, left> notin post];
		createCloneClasses(complementBucket);
	}
	
	for (currentClass <- cloneClasses) {
		for (currentClone <- cloneClasses[currentClass]) {
			checkForInnerClones(currentClone.left);
			checkForInnerClones(currentClone.right);
		}
	}
	
	for (subCloneClas <- subCloneClasses) {
		cloneClasses = delete(cloneClasses, subCloneClas);
	}

	printCloneResults();
}

public void chooseSubtreesByMass(Statement stylesheetAsts) {
	if (cloneType == 1) {
		[addSubtreeToBucket(x) | /node x := stylesheetAsts, calculateMass(x) >= massThreshold, !(Type a := x)];
	} else {
		[addSubtreeToBucket(normalizeNodeDec(x)) | /node x := stylesheetAsts, calculateMass(x) >= massThreshold, !(Type a := x)];
	}
}

public int addSubtreeToBucket(node tree) {
	loc location = getLocationOfNode(tree);

	if (cloneType == 3) {
		tree = getBestKey(tree);
	}
	
	if (buckets[tree]?) {
		buckets[tree] += <tree, location>;
	} else {
		buckets[tree] = [<tree, location>];
	}
	
	return 1;
}

public void createCloneClasses(lrel[tuple[node n,loc l] left, tuple[node n,loc l] right] complementBucket) {
	for (treeRelation <- complementBucket, calculateSimilarity(treeRelation.left.n, 
		treeRelation.right.n) >= similarityThreshold) {
			placeCloneInClass(treeRelation);
	}
}

public void placeCloneInClass(tuple[tuple[node n,loc l] left, tuple[node n, loc l] right] treeRelation) {
	if (cloneClasses[treeRelation.left.n]?) {
		cloneClasses[treeRelation.left.n] += treeRelation;
	} else {
		cloneClasses[treeRelation.left.n] = [treeRelation];
	}
}

public node normalizeNodeDec(node ast) {
	return visit (ast) {
		case n:ruleSet(list[Type] selector, list[Declaration] declarations) => normalizedRuleset(n, declarations)
		case n:class(str name) => normalizedSelector(n) 
    	case n:id(str name) => normalizedSelector(n)
    	case n:domElement(str name) => normalizedSelector(n)
	};
}

public Statement normalizedRuleset(Statement s, list[Declaration] declarations) {
	Statement rs = ruleSet([], declarations);
	rs@src = s@src;
	return rs;
}

public Type normalizedSelector(Type n) {
	Type sel = class("default");
	sel@src = n@src;
	return sel;
}

public void checkForInnerClones(tuple[node n,loc l] tree) {
	visit (tree.n) {
		case node x: {
			if (x != tree.n && calculateMass(x) >= massThreshold) {
				if (isMemberOfClones(<x, getLocationOfNode(x)>)) {			
					subCloneClasses += x;
				}
			}
		}
	}
}

public bool isMemberOfClones(tuple[node n, loc l] current) {
	for (currentCloneClass <- cloneClasses) {
		for (tuple[tuple[node n, loc l] left, tuple[node n, loc l] right] pair <- cloneClasses[currentCloneClass]) {
			if ((current.l <= pair.left.l && pair.left.n == current.n) ||
				(current.l <= pair.right.l && pair.right.n == current.n)) {
				if (cloneClasses[current.n]?) {
					if (size(cloneClasses[current.n]) == size(cloneClasses[currentCloneClass])) {
						return true;
					}
				}
			} 
		}
	}
	return false;
}

public num calculateSimilarity(node t1, node t2) {
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
		case Declaration n: result = n@src;
		case Expression n: result = n@src;
		case Statement n: result = n@src;
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

int calculateMass(node currentNode) = size([n | /node n := currentNode]);

public void printCloneResults() {
	println();
	
	int counting = 0;
	int lines = 0;
	
	set[loc] clonePairsPerClass = {};
	//iprintln("Here come the clones!");
	for (currentClass <- cloneClasses) {
		//iprintln("Total clone pairs in this class: <size(cloneClasses[currentClass])>");
		clonePairsPerClass = {};
		for (currentClone <- cloneClasses[currentClass]) {
			clonePairsPerClass += currentClone[0][1];
			//clonePairsPerClass += currentClone[1][1];
			counting += 1;
		}
		for (uniqueClone <- clonePairsPerClass) {
			lines += size(readFileLines(uniqueClone));
			//iprintln(uniqueClone);
		}
		//iprintln("--------------------------------------------------");
	}
	
	iprintln("Site: <currentProject> - Type <cloneType> - Clone pairs: <counting> - Lines: <lines>");
}