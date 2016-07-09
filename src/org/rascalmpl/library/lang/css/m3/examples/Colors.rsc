module lang::css::m3::examples::Colors

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
import vis::Figure;
import vis::Render;

//Declaration stylesheetAST = createAstFromFile(|home:///Documents/workspace/Rascal/rascal/testCSS/examples/bibtex.css|);
Declaration stylesheetAST = createAstFromFile(|home:///Documents/workspace/Rascal/rascal/testCSS/sample-set/web-new/facebook.com.css|);

public void colorsAnalysis() {
	set[Color] colors = {rgb(red, green, blue, toReal(alpha)) | /color(int red, int green, int blue, num alpha) := stylesheetAST};
	render(hvcat([box([size(50), fillColor(c)]) | c <- colors]));
}