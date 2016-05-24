module lang::css::m3::examples::Clones

import lang::css::m3::AST;
import lang::css::m3::Core;

import IO;
import String;
import Relation;
import Set;
import Map;
import Node;
import List;
import Traversal;
import util::Math;

Statement stylesheetAST = createAstFromFile(|home:///workspace/testCSS/sandbox/amazon.css|);
M3 stylesheetM3 = createM3FromFile(|home:///workspace/testCSS/sandbox/amazon.css|);

public void type1Clone() {	
	list[Statement] rules = [];
	rel[Statement,Statement] clones = {};
	
	visit (stylesheetAST) {
		case ruleSet(list[Type] selector, list[Declaration] declarations): {
				parents = getTraversalContext();
		        parent = parents[1];
	        iprintln(parents[0]);
			if (ruleSet(selector, declarations) notin rules) {
				rules = rules + ruleSet(selector, declarations);
			} else {
				clones += <ruleSet(selector, declarations),ruleSet(selector, declarations)>;
			}
		}
	};
	
	//for (clone <- clones) {
	//	prettyPrint(clone[0]);
	//}
}