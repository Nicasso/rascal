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

//set[Statement] stylesheetAST = createAstsFromDirectory(|home:///workspace/Rascal/rascal/testCSS/examples/|);
M3 stylesheetM3 = createM3FromDirectory(|home:///Documents/workspace/Rascal/rascal/testCSS/examples/a/|);

public void calculateVolume() {
	int \all = 0;
	int code = 0;
	int blank = 0;
	int comment = 0;
	for (style <- stylesheets(stylesheetM3)) {
		\all += calculateAllLines(style);
		code += calculateLinesOfCode(style,stylesheetM3);
		blank += calculateBlankLines(style);
		comment += calculateLinesOfComments(stylesheetM3);
	}
	
	
	iprintln("All lines: <\all>");
	iprintln("Lines of code: <code>");
	iprintln("Blank lines: <blank>");
	iprintln("Lines of comments: <comment>");
}

int calculateAllLines(loc style) = size(readFileLines(style));	
int calculateLinesOfCode(loc style, M3 stylesheet) = (calculateAllLines(style)-calculateBlankLines(style)-calculateLinesOfComments(stylesheet));	
int calculateLinesOfComments(M3 style) = sum([0]+[calculateAllLines(d[1]) | d <- style@documentation]);
int calculateBlankLines(loc style) = size([line | line <- readFileLines(style), trim(line) == ""]); 
