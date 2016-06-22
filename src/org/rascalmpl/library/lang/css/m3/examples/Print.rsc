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
	
	Statement stylesheetAST = createAstFromFile(|home:///workspace/Rascal/rascal/testCSS/examples/fb.css|);
	
	iprintln(stylesheetAST);
	
	prettyPrint(stylesheetAST);
	
}