module lang::css::m3::examples::ClonesThesis

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
import Traversal;

private int massThreshold = 6;
private real similarityThreshold;
private loc currentProject;
private int cloneType;
private map[node, lrel[node, loc]] buckets = ();
private map[node, lrel[tuple[node n, loc l] L, tuple[node n, loc l] R]] cloneClasses = ();

public void detectClones(loc project, int cloneT) {
	cloneType = cloneT;
	currentProject = project;
	
	buckets = ();
	cloneClasses = ();
	similarityThreshold = if (cloneType <= 2) 1.0; else 0.80;
	
	Declaration stylesheetAst = createAstFromFile(project);
	
	chooseSubtrees(stylesheetAst);
	createRelationsInsideBuckets();
	printCloneResults();
}

private void createRelationsInsideBuckets() {
	for (bucket <- buckets, size(buckets[bucket]) >= 2) {
		lrel[tuple[node,loc] L, tuple[node,loc] R] complementBucket = buckets[bucket] * buckets[bucket];
		complementBucket = [p | p <- complementBucket, p.L != p.R];
		complementBucket = [<L, R> | [*_, <L,R>, *post] := complementBucket, <R, L> notin post];
		createCloneClasses(complementBucket);
	}
}

private void createCloneClasses(lrel[tuple[node n,loc l] L, tuple[node n,loc l] R] complementBucket) {
	for (treeRelation <- complementBucket, calculateSimilarity(treeRelation.L.n, 
		treeRelation.R.n) >= similarityThreshold) {
			placeCloneInClass(treeRelation);
	}
}

private void placeCloneInClass(tuple[tuple[node n,loc l] L, tuple[node n,loc l] R] treeRelation) {
	if (cloneClasses[treeRelation.L.n]?) {
		cloneClasses[treeRelation.L.n] += treeRelation;
	} else {
		cloneClasses[treeRelation.L.n] = [treeRelation];
	}
}

private void chooseSubtrees(Declaration stylesheetAsts) {
	if (cloneType == 1) {
		[addSubtreeToBucket(x, x) | /node x := stylesheetAsts, calculateMass(x) >= massThreshold, !(Type a := x)];
	} else {
		[addSubtreeToBucket(normalizeNodeDec(x), normalizeNodeDec(x)) | /node x := stylesheetAsts, calculateMass(x) >= massThreshold, !(Type a := x)];
	}
}

private node normalizeNodeDec(node ast) {
	return visit (ast) {
		case n:ruleSet(list[Expression] selector, list[Statement] declarations) => normalizedRuleset(n, declarations)
		case rm:ruleMedia(list[Type] mediaQueries, list[Declaration] ruleSets) => normalizedRuleMedia(rm, ruleSets)
		case ss:stylesheet(str name, list[Declaration] rules) => normalizedStylesheet(ss, rules)
		case cs:ruleCounterStyle(str name, list[Statement] declarations) => normalizedCounterStyle(cs, declarations)
		case im:ruleImport(str uri, list[Type] mediaQueries) => normalizedImport(im, uri)
		case rp:rulePage(str pseudo, list[Statement] declarations) => normalizedRulePage(rp, pseudo) 
	};
}

private Declaration normalizedRuleset(Declaration s, list[Statement] declarations) {
	Declaration rs = ruleSet([], declarations);
	rs@src = s@src;
	return rs;
}

private Declaration normalizedRuleMedia(Declaration s, list[Declaration] declarations) {
	Declaration rs = ruleMedia([], declarations);
	rs@src = s@src;
	return rs;
}

private Declaration normalizedStylesheet(Declaration s, list[Declaration] declarations) {
	Declaration rs = stylesheet("", declarations);
	rs@src = s@src;
	return rs;
}

private Declaration normalizedCounterStyle(Declaration s, list[Declaration] declarations) {
	Declaration rs = ruleCounterStyle("", declarations);
	rs@src = s@src;
	return rs;
}

private Declaration normalizedImport(Declaration s, str uri) {
	Declaration rs = ruleImport(uri, []);
	rs@src = s@src;
	return rs;
}

private Declaration normalizedRulePage(Declaration s, str pseudo) {
	Declaration rs = rulePage(pseudo, []);
	rs@src = s@src;
	return rs;
}

private num calculateSimilarity(node t1, node t2) {
	list[node] tree1 = [x | /node x := t1];
	list[node] tree2 = [x | /node x := t2];
	
	num s = size(tree1 & tree2);
	num l = size(tree1 - tree2);
	num r = size(tree2 - tree1); 
	
	return (2 * s) / (2 * s + l + r);
}

private loc getLocationOfNode(node subTree) {
	loc result;
	switch(subTree) {
		case Statement n: result = n@src;
		case Expression n: result = n@src;
		case Declaration n: result = n@src;
		case Type n: result = n@src;
	}
	return result;
}

private node getBestKey(node key) {
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

private int addSubtreeToBucket(node key, node subTree) {
	loc location = getLocationOfNode(subTree);
	
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

private int calculateMass(node currentNode) = size([n | /node n := currentNode]);

private void printCloneResults() {
	set[int] uniqueLines = {};
	set[loc] clonePairsPerClass = {};
	
	for (currentClass <- cloneClasses) {
		clonePairsPerClass = {};
		println("Clones class containing <size(cloneClasses[currentClass])> clone pair(s).");
		for (currentClone <- cloneClasses[currentClass]) {
			clonePairsPerClass += currentClone.L.l;
			clonePairsPerClass += currentClone.R.l;
			println("<currentClone.L.l> - <currentClone.R.l>");
		}
		println("");
		for (uniqueClone <- clonePairsPerClass) {
			for (i <- [uniqueClone.begin.line .. (uniqueClone.end.line+1)]) {
				uniqueLines += i;
			}
		}
	}
	
	println("File: <currentProject.file> - Clone type: <cloneType> - Total cloned lines: <size(uniqueLines)>");
}