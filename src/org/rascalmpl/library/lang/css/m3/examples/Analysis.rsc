module lang::css::m3::examples::Analysis

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

Statement stylesheetAST = createAstFromFile(|home:///workspace/Rascal/rascal/testCSS/examples/fb.css|);
M3 stylesheetM3 = createM3FromFile(|home:///workspace/Rascal/rascal/testCSS/examples/fb.css|);

public void declarationAnalysis() {	
	lrel[str,int] values = [];
	
	visit (stylesheetAST) {
		case declaration(str property, list[Type] declarationValues): {
			if (size(values[property]) == 0) {
				values += [<property,1>];
			} else {
				int val = (values[property][0])+1;
				values -= [<property,values[property][0]>];
				values += [<property,val>];
			}
		}
	};
	
	iprintln(sort(values));
}

public void declarationAnalysis2() {
	lrel[str,list[Declaration]] values = [];
	
	visit (stylesheetAST) {
		case d:declaration(str property, list[Type] declarationValues): {
			values += <property,[d]>;
		}
	};
	
	for (val <- sort(values)) {	
		visit (val[1]) {
			case \audio(num aud, str unit):  { iprintln("<val[0]>: <ppx(Type::audio(aud,unit))>"); }
		    case \angle(num angle, str unit): { iprintln("<val[0]>: <ppx(Type::angle(angle,unit))>"); }
		    case \color(int red, int green, int blue, num alpha): { iprintln("<val[0]>: <ppx(Type::color(red,green,blue,alpha))>"); }
		    case \expression(str expression): { iprintln("<val[0]>: <ppx(Type::expression(expression))>"); }
		    case \calc(str expression): { iprintln("<val[0]>: <ppx(Type::calc(expression))>"); }
		    case \frequency(num freq, str unit): { iprintln("<val[0]>: <ppx(Type::frequency(freq,unit))>"); }
		    case \function(str func, list[Type] exp): { iprintln("<val[0]>: <ppx(Type::function(func,exp))>"); }
		    case \ident(str ident): { iprintln("<val[0]>: <ppx(Type::ident(ident))>"); }
		    case \integer(int a): { iprintln("<val[0]>: <ppx(Type::integer(a))>"); }
		    case \length(num \len, str unit): { iprintln("<val[0]>: <ppx(Type::length(\len,unit))>"); }
		    case \percent(num \perc): { iprintln("<val[0]>: <ppx(Type::percent(\perc))>"); }
		    case \list(list[Type] pair): { iprintln("<val[0]>: <ppx(Type::\list(pair))>"); }
		    case \number(num number): { iprintln("<val[0]>: <ppx(Type::number(\number))>"); }
		    case \resolution(num \res, str unit): { iprintln("<val[0]>: <ppx(Type::resolution(\res,unit))>"); }
		    case \string(str \string): { iprintln("<val[0]>: <ppx(Type::string(\string))>"); }
		    case \time(num \time, str unit): { iprintln("<val[0]>: <ppx(Type::time(\time,unit))>"); }
		    case \uri(str \uri): { iprintln("<val[0]>: <ppx(Type::uri(\uri))>"); }
		};
	}
}

public void modifierAnalysis() {
	visit (stylesheetAST) {
		case d:declaration(str property, list[Type] declarationValues): {
			if (d@modifier?) {
				print("<trim(ppx(d))> - <d@src>\n");
			}
		}
	};
}

public int importantCounter() {
	return size([d | /d:declaration(str property, list[Type] declarationValues) := stylesheetAST, d@modifier?]);
}

public void modifierAnalysis2() {
	visit (stylesheetAST) {
		case d:declaration(str property, list[Type] declarationValues): {
			if (d@modifier?) {
				print("<trim(ppx(d))> - <d@src>\n");
			}
		}
	};
}

// From the paper: CSS Code Quality: A Metric for Abstractness

public void universality() {	
	map[str,int] values = ("all":0, "elements":0);
	
	visit (stylesheetAST) {
		case class(str name): {
			values["all"] += 1;
		}
		case id(str name): {
			values["all"] += 1;
		}
    	case domElement(str name): {
    		values["all"] += 1;
    		values["elements"] += 1;
    	}
	};
	
	real uni = toReal(values["all"]) / toReal(values["elements"]); 
	
	iprintln(uni);
}

// From the thesis: The A-B*-A Pattern of Undoing Style in Cascading Style Sheets

public void filterUndoingStyles(Statement rules) {
	list[Statement] possibleUndoingStyles;
	list[Statement] undoingStyles;
	
	// Maybe too much work for now...
}