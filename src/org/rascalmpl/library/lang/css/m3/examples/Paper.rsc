module lang::css::m3::examples::Paper

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

/**
 * From the paper: Complexity Metrics for Cascading Style Sheets
 */
 
public void metrics1() {

	list[loc] dirs = [
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/9gag|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/amazon|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/apple|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/ask|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/booking|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/cnn|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/dropbox|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/ebay|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/facebook|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/godaddy|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/live|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/mozilla|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/nytimes|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/paypal|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/pinterest|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/reddit|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/soundcloud|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/spotify|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/stackoverflow|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/twitch|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/twitter|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/vimeo|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/w3|,
		//|home:///workspace/Rascal/rascal/testCSS/sample-set/web/youtube|,
		
		|home:///workspace/Rascal/rascal/testCSS/sample-set/github/animate.css-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/balloon.css-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/blueprint-css-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/bootstrap-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/bulma-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/CSSgram-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/csshake-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/devices.css-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/Gumby-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/hint.css-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/Hover-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/icono-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/lesshat-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/Makisu-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/milligram-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/penthouse-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/photon-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/primer-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/ratchet-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/recess-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/sanitize.css-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/simpsons-in-css-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/tachyons-master|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/ungrid-gh-pages|,
	    |home:///workspace/Rascal/rascal/testCSS/sample-set/github/wtf-forms-master|
	];
	
	for (d <- dirs) {
		stylesheetM3 = createM3FromDirectory(d);
		
		//iprintln("RL: <ruleLength()>");
		//iprintln("NORB: <numberOfRuleBlocks()>");
		//iprintln("EM: <entropyMetrics()>");
		//iprintln("NOERB: <numberOfExtendedRuleBlocks()>");
		//iprintln("NOADPRB: <numberOfAttributesDefinedPerRuleBlock()>");
		//iprintln("NOCRB: <numberOfCohesiveRuleBlocks()>");
		iprintln("<d> <ruleLength()> <numberOfRuleBlocks()> <numberOfAttributesDefinedPerRuleBlock()> <numberOfCohesiveRuleBlocks()>"); 
	}
}

M3 stylesheetM3;
 
public int ruleLength() {	
	int ruleLength = 0;
	bool commentBlock = false;
	for (rule <- ruleSets(stylesheetM3)) {
		for (line <- readFileLines(rule)) {	
			if (contains(line,"/*") && !contains(line,"*/")) {
				commentBlock = true;
			} else if (commentBlock && contains(line,"*/")) {
				commentBlock = false;
			} else if (!(trim(line) == "")) {
				ruleLength += 1;
			}
		}
	}
	return ruleLength;
}

public int  numberOfRuleBlocks() {	
	return size(ruleSets(stylesheetM3));
}

// @TODO / IS THIS EVEN POSSIBLE? CREATING EQUIVALENCE CLASSES IS NOT DEFINE...
public int entropyMetrics() {
	return 1;
}

public int numberOfExtendedRuleBlocks() {	
	return size(ruleSets(stylesheetM3));
}

public real numberOfAttributesDefinedPerRuleBlock() {	
	return toReal(size(declarations(stylesheetM3)))/toReal(size(ruleSets(stylesheetM3)));
}

public int numberOfCohesiveRuleBlocks() {	
	return size([rule | rule <- ruleSets(stylesheetM3), size({a | <e,a> <- stylesheetM3@containment, e == rule, isDeclaration(a)}) == 1]);
}