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
		case rs:ruleSet(list[Type] selector, list[Declaration] declarations): {
			if (rs notin rules) {
				rules += rs;
			} else {
				clones += <rs,rules[indexOf(rules, rs)]>;
			}
		}
	};
	
	for (clone <- clones) {
		println(clone[0]@src);
		prettyPrint(clone[0]);
		println(clone[1]@src);
		prettyPrint(clone[1]);
	}
}