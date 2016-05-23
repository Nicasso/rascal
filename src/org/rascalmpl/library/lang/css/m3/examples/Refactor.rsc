module lang::css::m3::examples::Refactor

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

Statement stylesheetAST = createAstFromFile(|home:///workspace/testCSS/sandbox/style.css|);

public void refactorExample1() {
	
	prettyPrint(stylesheetAST);
	
	newAST = visit (stylesheetAST) {
		case ruleSet(list[Type] selector, list[Declaration] declarations) => ruleSet(selector, marginShorthand(declarations))
	};
	
	iprintln("-----------------------------------------------");
	
	prettyPrint(newAST);
}

public list[Declaration] marginShorthand(list[Declaration] declarations) {
	requiredDeclarations = ["margin-left", "margin-right", "margin-top", "margin-bottom"];
	
	map[str, Type] declarationsValues = ();
	list[Declaration] newDeclarations = [];
	for (n <- declarations) {
		visit (n) {
			case declaration(str property, list[Type] values): {
				if (property in requiredDeclarations) {
					requiredDeclarations = requiredDeclarations - [property];
					declarationsValues += (property:values[0]);
					if (size(requiredDeclarations) == 0) {
						newDeclarations += declaration("margin", [declarationsValues["margin-top"],declarationsValues["margin-right"],declarationsValues["margin-bottom"],declarationsValues["margin-left"]]);
					}
				} else {
					newDeclarations += n;
				}
			}
		}
	}
	return newDeclarations;
}
