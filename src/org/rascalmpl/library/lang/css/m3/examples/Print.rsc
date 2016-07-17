module lang::css::m3::examples::Print

import lang::css::m3::AST;
import lang::css::m3::Core;
import lang::css::m3::PrettyPrinter;

import IO;
import String;
import Relation;
import Set;
import Map;
import Node;
import List;
import util::Math;

public void go() {
	
	Declaration stylesheetAST = createAstFromFile(|home:///Documents/workspace/Rascal/rascal/testCSS/examples/test.css|);
	
	M3 stylesheetM3 = createM3FromFile(|home:///Documents/workspace/Rascal/rascal/testCSS/examples/test.css|);
	
	iprintln(stylesheetM3);	
}