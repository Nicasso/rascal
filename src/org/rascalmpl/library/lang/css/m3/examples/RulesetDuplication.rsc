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

rel[list[str],loc,int] duplications = {};

rel[list[str],loc,int] allPossibleLineBlocks = {};

M3 stylesheetM3 = createM3FromFile(|home:///workspace/testCSS/sandbox/amazon.css|);

public void detectRulesetDuplication() {

	
}