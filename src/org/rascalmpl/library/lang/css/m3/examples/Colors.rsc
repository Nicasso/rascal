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

Statement stylesheetAST = createAstFromFile(|home:///workspace/testCSS/sandbox/colors.css|);
M3 stylesheetM3 = createM3FromFile(|home:///workspace/testCSS/sandbox/colors.css|);

public void colorsAnalysis() {
	list[Color] colors = [rgb(red, green, blue, toReal(alpha)) | /color(int red, int green, int blue, num alpha) := stylesheetAST];
	render(hcat([box([size(50), fillColor(c), lineColor(c)]) | c <- sort(colors)]));
}