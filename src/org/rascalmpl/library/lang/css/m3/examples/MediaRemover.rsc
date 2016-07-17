module lang::css::m3::examples::MediaRemover

import lang::css::m3::AST;
import lang::css::m3::Core;
import lang::css::m3::PrettyPrinter;
import demo::common::Crawl;
import util::Math;
import IO;
import List;
import Map;
import Tuple;
import Type;
import Set;
import Prelude;
import String;
import Relation;
import ListRelation;
import util::Math;
import DateTime;
import Traversal;

public void removeMediaRules() {
	
	Declaration ast = createAstFromFile(|home:///workspace/Rascal/rascal/testCSS/sample-set/web-new/ok.ru.css|);

	Declaration newAst = visit (ast) {
		case n:ruleMedia(list[Type] mediaQueries, list[Declaration] ruleSets) => ruleMedia(mediaQueries, [])
	};
	
	exportCSSToFile(|home:///workspace/Rascal/rascal/testCSS/sample-set/noMedia/ok.ru.clean2.css|, ast);
}