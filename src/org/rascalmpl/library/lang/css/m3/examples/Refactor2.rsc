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
		case \n:audio(num aud, str unit) => removeUnitAfterZero(aud, n)
	    case \n:angle(num angle, str unit) => removeUnitAfterZero(angle, n)
	    case \n:frequency(num freq, str unit) => removeUnitAfterZero(freq, n)
	    case \n:length(num \len, str unit) => removeUnitAfterZero(len, n)
	    case \n:percent(num \perc) => removeUnitAfterZero(perc, n)
	    case \n:resolution(num \res, str unit) => removeUnitAfterZero(res, n)
	    case \n:time(num \time, str unit) => removeUnitAfterZero(time, n)
	};
	prettyPrint(newAST);
}

public Type removeUnitAfterZero(num number, Type original) {
	if (number == 0) {
		return \integer(0);
	}
	return original;
}