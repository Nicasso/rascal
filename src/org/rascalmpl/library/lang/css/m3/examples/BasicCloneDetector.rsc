module lang::css::m3::examples::BasicCloneDetector

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

data CloneType = One() | Two() | Three();

private loc currentProject = |home:///workspace/Rascal/rascal/testCSS/examples/a|;
private int massThreshold = 5;
private real similarityThreshold;
private CloneType cloneType;
private map[node, list[node]] buckets = ();
private lrel[node L, node R] clonePairs = [];

public void detectClones(CloneType cloneT) {
	cloneType = cloneT;

	buckets = ();
	clonePairs = [];
	subCloneClasses = [];
	
	set[Statement] stylesheetAsts = createAstsFromDirectory(currentProject);

	if (cloneType == One() || cloneType == Two()) {
		similarityThreshold = 1.0;
	} else {
		similarityThreshold = 0.75;
	}
	
	// Add all the subtrees with a mass higher than the massThreshold into a bucket.
	// Depening on the clone type we want to find, we normalize the subtrees.
	chooseSubtrees(stylesheetAsts);
	
	iprintln("BUCKETS: <size(buckets)>");
	
	for (bucket <- buckets, size(buckets[bucket]) >= 2) {
		lrel[node L, node R] complementBucket = buckets[bucket] * buckets[bucket];
		createCloneClasses(complementBucket);
	}
	
	//clonePairs = [p | p <- clonePairs, p.L != p.R];
	//clonePairs = [<L, R> | [*_, <L,R>, *post] := clonePairs, <R, L> notin post];
	
	iprintln("PAIRS: <size(clonePairs)>");
	
	for (currentClone <- clonePairs) {
		checkForInnerClones(currentClone.L);
		checkForInnerClones(currentClone.R);
	}

	printCloneResults();
}

public void checkForInnerClones(node tree) {
	visit (tree) {
		case node x: {
			if (isMemberOfClones(x)) {
				//iprintln("FUCK YEAH!");
				int a;
			}
			// Only if the tree is not equal to itself, and has a certain mass.
			//if (x != tree && calculateMass(x) >= massThreshold) {
			//	loc location = getLocationOfNode(x);
			//	if (location != currentProject && size(readFileLines(location)) < 3) {
			//		if (isMemberOfClones(x)) {
			//			iprintln("FUCK YEAH!");
			//		}
			//	}
			//}
		}
	}
}

public bool isMemberOfClones(node current) {
	for (tuple[node L, node R] pair <- clonePairs) {
		if (pair.L == current || pair.R == current) {
			//clonePairs -= pair;
			return true;
		} 
	}
	return false;
}

public void createCloneClasses(lrel[node L, node R] complementBucket) {
	for (treeRelation <- complementBucket, calculateSimilarity(treeRelation.L, 
		treeRelation.R) >= similarityThreshold) {
			clonePairs += treeRelation;
	}
}

public void chooseSubtrees(set[Statement] stylesheetAsts) {
	if (cloneType == One()) {
		[placeSubtreeIntoBucket(x, x) | /node x := stylesheetAsts, calculateMass(x) >= massThreshold, !(Type a := x)];
	} else {
		[placeSubtreeIntoBucket(normalizeNodeDec(x), normalizeNodeDec(x)) | /node x := stylesheetAsts, calculateMass(x) >= massThreshold, !(Type a := x)];
	}
}

// Normalize all variable types of the leaves in a tree.
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
	Type sel = class("normal");
	sel@src = n@src;
	return sel;
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

public int placeSubtreeIntoBucket(node key, node subTree) {
	loc location = getLocationOfNode(subTree);
	
	if (size(readFileLines(location)) < 3) {
		return 0;
	}
	
	if (cloneType == Three()) {
		key = getBestKey(key);
	}
	
	if (buckets[key]?) {
		buckets[key] += subTree;
	} else {
		buckets[key] = [subTree];
	}
	
	return 0;
}

int calculateMass(node currentNode) = size([n | /node n := currentNode]);

public void printCloneResults() {
	int counting = 0;
	
	iprintln("Here come the clones!");

	for (currentClone <- clonePairs) {
		counting += 1;
		println("<getLocationOfNode(currentClone[0])> - <getLocationOfNode(currentClone[1])>");
	}
	
	iprintln("Total amount of clone pairs: <counting>");
}