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

Statement stylesheetAST = createAstFromFile(|home:///workspace/Rascal/rascal/testCSS/examples/bibtex.css|);

public void colorsAnalysis() {
	list[Color] colors = [rgb(red, green, blue, toReal(alpha)) | /color(int red, int green, int blue, num alpha) := stylesheetAST];
	render(hcat([box([size(50), fillColor(c), lineColor(c)]) | c <- sort(colors)]));
}