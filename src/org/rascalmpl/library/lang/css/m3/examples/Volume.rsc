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

Statement stylesheetAST = createAstFromFile(|home:///workspace/Rascal/rascal/testCSS/examples/bibtex.css|);
M3 stylesheetM3 = createM3FromFile(|home:///workspace/Rascal/rascal/testCSS/examples/bibtex.css|);

public void calculateVolume() {
	for (style <- stylesheets(stylesheetM3)) {
		iprintln(style);
		iprintln("All lines: <calculateAllLines(style)>");
		iprintln("Lines of code: <calculateLinesOfCode(style,stylesheetM3)>");
		iprintln("Blank lines: <calculateBlankLines(style)>");
		iprintln("Lines of comments: <calculateLinesOfComments(stylesheetM3)>");
	}
}

int calculateAllLines(loc style) = size(readFileLines(style));	
int calculateLinesOfCode(loc style, M3 stylesheet) = (calculateAllLines(style)-calculateBlankLines(style)-calculateLinesOfComments(stylesheet));	
int calculateLinesOfComments(M3 style) = sum([0]+[calculateAllLines(d[1]) | d <- style@documentation]);
int calculateBlankLines(loc style) = size([line | line <- readFileLines(style), trim(line) == ""]); 
