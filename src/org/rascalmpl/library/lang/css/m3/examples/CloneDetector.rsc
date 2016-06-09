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

loc currentProject = |home:///workspace/Rascal/rascal/testCSS/examples/a|;

int cloneType;

map[node, lrel[node, loc]] buckets = ();
map[node, lrel[tuple[node, loc] L, tuple[node, loc] R]] cloneClasses = ();
list[node] subCloneClasses = [];

public void detectClones(int cloneT) {
	cloneType = cloneT;
	
	iprintln("Attack of the clones!");
	println(printTime(now(), "HH:mm:ss"));
	
	buckets = ();
	cloneClasses = ();
	subCloneClasses = [];
	
	set[Statement] stylesheetAsts = createAstsFromDirectory(currentProject);

	if (cloneType <= 2) {
		similarityThreshold = 1.0;
	} else {
		similarityThreshold = 0.75;
	}
	
	// Add all the subtrees with a mass higher than the massThreshold into a bucket.
	// Depening on the clone type we want to find, we normalize the subtrees.
	placeSubtreesIntoBuckets(stylesheetAsts);
	
	println("Done with indexing the subtrees into buckets.");
	println(printTime(now(), "HH:mm:ss"));
	
	for (bucket <- buckets, size(buckets[bucket]) >= 2) {
		lrel[tuple[node,loc] L, tuple[node,loc] R] complementBucket = buckets[bucket] * buckets[bucket];
		complementBucket = [p | p <- complementBucket, p.L != p.R];
		complementBucket = [<L, R> | [*_, <L,R>, *post] := complementBucket, <R, L> notin post];
		createCloneClasses(complementBucket);
	}
	
	println("Done with finding clones from buckets and created cloneClasses.");
	println(printTime(now(), "HH:mm:ss"));
	
	// Loop through all the clone classes and remove all smaller subclones.
	for (currentClass <- cloneClasses) {
		for (currentClone <- cloneClasses[currentClass]) {
			checkForInnerClones(currentClone.L);
			checkForInnerClones(currentClone.R);
		}
	}
	
	println("Indexed all thesmaller subclones");
	println(printTime(now(), "HH:mm:ss"));
	
	// Remove the subclones one by one from the cloneClasses.
	for (subCloneClas <- subCloneClasses) {
		cloneClasses = delete(cloneClasses, subCloneClas);
	}

	println("Removed all subclones from the cloneClasses");
	println(printTime(now(), "HH:mm:ss"));
	
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

public void placeSubtreesIntoBuckets(set[Statement] stylesheetAsts) {
	if (cloneType == 1) {
		[addSubTreeToMap(x, x) | /node x := stylesheetAsts, calculateMass(x) >= massThreshold, !(Type a := x)];
	} else {
		[addSubTreeToMap(normalizeNodeDec(x), normalizeNodeDec(x)) | /node x := stylesheetAsts, calculateMass(x) >= massThreshold, !(Type a := x)];
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
	Type sel = class("lol");
	sel@src = n@src;
	return sel;
}

public void checkForInnerClones(tuple[node,loc] tree) {
	visit (tree[0]) {
		case node x: {
			// Only if the tree is not equal to itself, and has a certain mass.
			if (x != tree[0] && calculateMass(x) >= massThreshold) {
				loc location = getLocationOfNode(x);
				if (location != currentProject && isMemberOfClones(<x, location>)) {			
					subCloneClasses += x;
				}
			}
		}
	}
}

public bool isMemberOfClones(tuple[node n, loc l] current) {
	for (currentcloneClass <- cloneClasses) {
		for (tuple[tuple[node n, loc l] L, tuple[node n, loc l] R] pair <- cloneClasses[currentcloneClass]) {
			if ((current.l <= pair.L.l && pair.L.n == current.n) ||
				(current.l <= pair.R.l && pair.R.n == current.n)) {
				if (cloneClasses[current.n]?) {
					if (size(cloneClasses[current.n]) == size(cloneClasses[currentcloneClass])) {
						return true;
					}
				}
			} 
		}
	}
	return false;
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
	if (Declaration d := subTree) { 
		if (d@src?) {
			return d@src;
		}
	} else if (Expression e := subTree) {
		if (e@src?) {
			return e@src;
		}
	} else if (Statement s := subTree) {
		if (s@src?) {
			return s@src;
		}
	} else if (Type t := subTree) {
		if (t@src?) {
			return t@src;
		}
	}
	throw "Could not retrieve the source code location.";
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

public int addSubTreeToMap(node key, node subTree) {
	loc location = getLocationOfNode(subTree);
	
	if (location == currentProject) {
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
	println();
	
	int counting = 0;
	
	set[loc] clonePairsPerClass = {};
	iprintln("Here come the clones!");
	for (currentClass <- cloneClasses) {
		iprintln("Total clone pairs in this class: <size(cloneClasses[currentClass])>");
		clonePairsPerClass = {};
		for (currentClone <- cloneClasses[currentClass]) {
			clonePairsPerClass += currentClone[0][1];
			clonePairsPerClass += currentClone[1][1];
			counting += 1;
		}
		for (uniqueClone <- clonePairsPerClass) {
			iprintln(uniqueClone);
		}
		iprintln("--------------------------------------------------");
	}
	
	iprintln("Total amount of clone pairs: <counting>");
}