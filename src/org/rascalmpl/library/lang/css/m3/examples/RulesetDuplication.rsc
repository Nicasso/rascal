module lang::css::m3::examples::RulesetDuplication

import lang::css::m3::AST;
import lang::css::m3::Core;
import IO;
import List;
import Tuple;
import String;
import Relation;
import Prelude;
import util::Math;
import demo::common::Crawl;

Statement stylesheetAST = createAstFromFile(|home:///Documents/workspace/Rascal/rascal/testCSS/examples/ruleclones.css|);

list[Type] currentSelectors = [];
list[Declaration] currentDeclarations = [];

rel[Type, list[Declaration]] allRules = {};

public void detectRulesetDuplication() {

	currentSelectors = [];
	currentDeclarations = [];
	allRules = {};
	
	prettyPrint(stylesheetAST); 

	newAST = visit (stylesheetAST) {
		case rs:ruleSet(list[Type] selector, list[Declaration] declarations) => lawl(selector,declarations)
		case cs:combinedSelector(list[Expression] selectors): {
			currentSelectors += cs;
		}
		case d:declaration(str property, list[Type] values): {
			currentDeclarations += d;
		}
	};
	
	iprintln("-----------------------------------------------");
	
	prettyPrint(newAST);
}

public Statement lawl(list[Type] selector, list[Declaration] declarations) {
	if (size(currentSelectors) > 0 && size(currentDeclarations) > 0) {
		for (sel <- currentSelectors) {
			if (<sel, sort(currentDeclarations)> in allRules) {
				iprintln("CLONE");
				return comment("clone");
			} else {
				allRules += <sel, sort(currentDeclarations)>;
			}
		}
	}
	currentSelectors = [];
	currentDeclarations = [];
	return ruleSet(selector,declarations);
}