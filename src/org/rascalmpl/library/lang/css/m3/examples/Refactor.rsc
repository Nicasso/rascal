module lang::css::m3::examples::Refactor

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

Statement stylesheetAST = createAstFromFile(|home:///workspace/Rascal/rascal/testCSS/examples/refactor.css|);

map[str,list[str]] requiredDeclarations;
map[str,int] remainingDeclarations;

public void refactorExample1() {
	
	prettyPrint(stylesheetAST);
	
	newAST = visit (stylesheetAST) {
		case ruleSet(list[Type] selector, list[Declaration] declarations) => ruleSet(selector, checkPossibleShorthands(declarations))
	};
	
	iprintln("-----------------------------------------------");
	
	prettyPrint(newAST);
}

public void resetDeclarations() {
	requiredDeclarations = (
		"margin": ["margin-top", "margin-right", "margin-bottom", "margin-left"],
		"padding": ["padding-top", "padding-right", "padding-bottom", "padding-left"],
		"background": ["background-color", "background-image", "background-repeat", "background-position", "background-attachment"],
		"font": ["font-style", "font-weight", "font-size", "line-height", "font-family"],
		"border": ["border-width", "border-style", "border-color"],
		"list": ["list-style-type", "list-style-position", "list-style-image"]
	);
	
	remainingDeclarations = (
		"margin": size(requiredDeclarations["margin"]),
		"padding": size(requiredDeclarations["padding"]),
		"background": size(requiredDeclarations["background"]),
		"font": size(requiredDeclarations["font"]),
		"border": size(requiredDeclarations["border"]),
		"list":size(requiredDeclarations["list"])
	);
}

public list[Type] setDeclarationValues(str property, map[str, Type] declarationValues) {
	list[Type] returnValues = [];
	for (p <- requiredDeclarations[property]) {
		returnValues += declarationValues[p];
	}
		
	return returnValues;
}

public list[Declaration] checkPossibleShorthands(list[Declaration] declarations) {	
	map[str, Type] declarationsValues = ();
	list[Declaration] newDeclarations = [];
	
	resetDeclarations();
	
	for (n <- declarations) {
		visit (n) {
			case declaration(str property, list[Type] values): {
				if (checkProperty(property)) {
					declarationsValues += (property:values[0]);
					str sh = checkPossibleRefactoring();
					if (sh != "") {
						newDeclarations += declaration(sh, setDeclarationValues(sh, declarationsValues));
					}
				} else {
					newDeclarations += n;
				}
			}
		}
	}
	return newDeclarations;
}

public str checkPossibleRefactoring() {
	for (d <- requiredDeclarations) {
		if (remainingDeclarations[d] == 0) {
			remainingDeclarations[d] = size(requiredDeclarations[d]);
			return d;
		}
	}
	return "";
}

public bool checkProperty(property) {
	for (d <- requiredDeclarations) {
		if (property in requiredDeclarations[d]) {
			remainingDeclarations[d] -= 1;
			return true;
		}
	}
	return false;
}