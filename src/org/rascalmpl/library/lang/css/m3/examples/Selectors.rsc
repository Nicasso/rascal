module lang::css::m3::examples::Selectors

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

Statement stylesheetAST = createAstFromFile(|home:///workspace/Rascal/rascal/testCSS/examples/bibtex.css|);
M3 stylesheetM3 = createM3FromFile(|home:///workspace/Rascal/rascal/testCSS/examples/bibtex.css|);

public void selectorAnalysis() {
	map[str,int] values = ("classes":0, "ids":0, "elements":0);
	
	visit (stylesheetAST) {
		case class(str name): {
			values["classes"] += 1;
		}
		case id(str name): {
			values["ids"] += 1;
		}
    	case domElement(str name): {
    		values["elements"] += 1;
    	}
	};
	
	iprintln(values);
	
}

public void selectorAnalysis2() {
	map[str,int] values = ("selectors":0, "total":0, "min":1, "max":0, "average":0);
	
	visit (stylesheetAST) {
		case combinedSelector(list[Expression] selectors): {
			values["total"] += size(selectors);
			values["selectors"] += 1;
			if (size(selectors) > values["max"]) {
				values["max"] = size(selectors);
			}
			if (size(selectors) < values["min"]) {
				values["min"] = size(selectors);
			}
		}
	};
	
	values["average"] = values["total"]/values["selectors"];
	
	iprintln(values);
	
}