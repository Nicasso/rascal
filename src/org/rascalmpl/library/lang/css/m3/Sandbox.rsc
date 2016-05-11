module lang::css::m3::Sandbox

import lang::css::m3::AST;
import lang::css::m3::Core;

import IO;
import String;
import Relation;
import Set;
import Map;
import Node;
import List;

public void lol() {
	Statement stylesheet = createAstFromFile(|home:///workspace/testCSS/sandbox/style.css|);
	
	//iprintln(stylesheet);
	
	newAST = visit (stylesheet) {
		case ruleSet(list[Type] selector, list[Declaration] declarations): {
			//checkDeclarations(declarations);
			iprintln("");
		}
		case declaration(str property, list[Type] values) => declaration("COOL", values)
	};
	
	iprintln(newAST);	
}

public void checkDeclarations(list[Declaration] declarations) {
	requiredDeclarations = ["margin-left","margin-right","margin-top","margin-bottom"];
	
	for (n <- declarations) {
		visit (n) {
			case declaration(str property, list[Type] values): {
				iprintln("DECL: "+property);
				if (property in requiredDeclarations) {
					requiredDeclarations = requiredDeclarations - [property];
					iprintln("REMOVE");
				}
				if (size(requiredDeclarations) == 0) {
					iprintln("VET GOOD!");
				}
			}
		}
	}
}