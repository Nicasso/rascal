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

public int calculateAllLines(loc style) {
	return size(readFileLines(style));	
}

public int calculateLinesOfCode(loc style, M3 stylesheet) {
	return (calculateAllLines(style)-calculateBlankLines(style)-calculateLinesOfComments(stylesheet));	
}

public int calculateLinesOfComments(M3 style) {
	return sum([0]+[calculateAllLines(d[1]) | d <- style@documentation]);
}

public int calculateBlankLines(loc style) {
	return size([line | line <- readFileLines(style), trim(line) == ""]); 
}