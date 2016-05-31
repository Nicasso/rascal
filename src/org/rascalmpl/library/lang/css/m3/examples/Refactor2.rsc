module lang::css::m3::examples::Refactor2

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

Statement stylesheetAST = createAstFromFile(|home:///workspace/Rascal/rascal/testCSS/examples/test.css|);

public void zeroUnits() {
	newAST = visit (stylesheetAST) {
		case \n:audio(num aud, str unit):  { 
			if (aud == 0) {
				println("Unit used after zero value at: <n@src>");
			}
		}
	    case \n:angle(num angle, str unit): {
    		if (angle == 0) {
				println("Unit used after zero value at: <n@src>");
			} 
	    }
	    case \n:frequency(num freq, str unit): {
	    	if (freq == 0) {
				println("Unit used after zero value at: <n@src>");
			}
	    }
	    case \n:length(num \len, str unit) => \integer(1)
	    case \n:percent(num \perc): {
	    	if (perc == 0) {
				println("Unit used after zero value at: <n@src>");
			} 
	    }
	    case \n:resolution(num \res, str unit): {
	    	if (res == 0) {
				println("Unit used after zero value at: <n@src>");
			}
	    }
	    case \n:time(num \time, str unit): {
	    	if (time == 0) {
				println("Unit used after zero value at: <n@src>");
			} 
	    }
	};
	prettyPrint(newAST);
}

public Type removeUnitAfterZero(num number, Type original) {
	if (number == 0) {
		return \integer(0);
	}
	return original;
}