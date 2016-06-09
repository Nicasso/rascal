module lang::css::m3::examples::Duplication

import lang::css::m3::AST;
import lang::css::m3::Core;
import IO;
import List;
import Tuple;
import String;
import Relation;
import Prelude;
import util::Math;
import demo::common::Crawl;

rel[list[str],loc,int] duplications = {};

rel[list[str],loc,int] allPossibleLineBlocks = {};

M3 stylesheetM3 = createM3FromFile(|home:///workspace/Rascal/rascal/testCSS/examples/bootstrapconventions.css|);

public int detectDuplication() {

	duplications = {};
	allPossibleLineBlocks = {};

	for (currentLocation <- stylesheets(stylesheetM3)) {
		list[str] sixLines = [];
		int i = 0;
		int currentLine = 1;
		
		for (line <- readFileLines(currentLocation)) {
			line = trim(line);
			currentLine += 1;
			
			if( i < 6) {
				sixLines += line;
				i += 1;
			} else {
				sixLines = drop(1, sixLines);
				sixLines += line;
				
				allPossibleLineBlocks += {<sixLines, currentLocation, currentLine-6>};
			}
		}
	}
	
	lrel[loc,int,list[str]] dups = [ <y,z,x> | <x,y,z> <- allPossibleLineBlocks, size(allPossibleLineBlocks[x]) > 1];
	
	dups = sort(dups);

	totalDupLines = 0;
	dupLines = 6;
	
	for (singleDup <- dups) {
		tuple[loc,int,list[str]] nextDup = <singleDup[0],singleDup[1]+1,singleDup[2]>;
		bool found = findLongerDups(dups, nextDup);
		if (found) {
			dupLines += 1;
		} else {
			totalDupLines += dupLines;
			dupLines = 6;
		}
	}
	
	return totalDupLines;
}

public bool findLongerDups(lrel[loc,int,list[str]] dups, tuple[loc,int,list[str]] dupToFind) {
	for (singleDup <- dups) {
		if(singleDup[0] == dupToFind[0] && singleDup[1] == dupToFind[1]) {
			return true;
		}
	}
	return false;
}