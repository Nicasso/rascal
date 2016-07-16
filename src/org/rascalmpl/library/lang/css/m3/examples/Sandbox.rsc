module lang::css::m3::examples::Sandbox

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

loc location = |home:///Documents/workspace/Rascal/rascal/testCSS/examples/bibtex.css|;
Statement stylesheetAST = createAstFromFile(|home:///Documents/workspace/Rascal/rascal/testCSS/examples/bibtex.css|);
M3 stylesheetM3 = createM3FromFile(|home:///Documents/workspace/Rascal/rascal/testCSS/examples/bibtex.css|);

void go() {
	println(|home:///Documents/workspace/Rascal/rascal/testCSS/examples/bibtex.css|);

	println("Blank: <calculateBlankLines(location)>");
	println("Comment: <calculateLinesOfComments(stylesheetM3)>");
	println("Code: <calculateLinesOfCode(location, stylesheetM3)>");
	
	println("NADPB: <NADPB(stylesheetM3)>");
	println("NOCRB: <NOCRB(stylesheetM3)>");
	
	println("Ids:");
	for (a <- avoidIds(stylesheetAST)) {
		println(a);
	}
	
	println("Fallback:");
	vendorPrefixFallback(stylesheetAST);
	
	println("Before");
	prettyPrint(stylesheetAST);
	println("After");
	prettyPrint(vendorPrefixFallbackRefactor(stylesheetAST));
}

int calculateBlankLines(loc stylesheet) = size([0 | line <- readFileLines(stylesheet), trim(line) == ""]); 
int calculateLinesOfComments(M3 stylesheetM3) = sum([0]+[calculateAllLines(d[1]) | d <- stylesheetM3@documentation]);
int calculateLinesOfCode(loc stylesheet, M3 stylesheetM3) = (size(readFileLines(stylesheet))-calculateBlankLines(stylesheet)-calculateLinesOfComments(stylesheetM3));

real NADPB(M3 stylesheetM3) = toReal(size(declarations(stylesheetM3)))/toReal(size(ruleSets(stylesheetM3)));

int NOCRB(M3 stylesheetM3) = size([0 | rule <- ruleSets(stylesheetM3), size({a | <e,a> <- stylesheetM3@containment, e == rule, isDeclaration(a)}) == 1]);

list[str] avoidIds(Statement stylesheetAST) = ["ID selector used at: <i@src>" | /i:id(str name) := stylesheetAST];

void vendorPrefixFallback(Statement stylesheetAST) {
  list[str] prefixes = ["-moz-", "-webkit-", "-o-", "-ms-"];
  set[str] required = {};
  visit (stylesheetAST) {
    case rs:ruleSet(list[Expression] selector, list[Declaration] declarations): {
	  if (size(required) > 0) {
	    println("One or more vendor specific declarations are used without a fallback of the standard property at: <rs@src>");
	    required = {};
	  }
	}
    case d:declaration(str property, list[Type] values): {
      if (property in required) {
	    required -= property;
	  } else {
	    for (pre <- prefixes, startsWith(property, pre)) {
	      required += replaceFirst(property, pre, "");
		  break;
	    }
	  }
    }
  };
}

Statement vendorPrefixFallbackRefactor(Statement stylesheetAST) {
  return visit (stylesheetAST) {
    case ruleSet(list[Expression] selector, list[Declaration] declarations) => vendorPrefixFallbackRefactorHelper(selector, declarations)
  };
}

Statement vendorPrefixFallbackRefactorHelper(list[Expression] selector, list[Declaration] declarations) {
  list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
  set[tuple[str,list[Type]]] required = {};
  for (d:declaration(str property, list[Type] values) <- declarations) {
    if (<property,values> in required) {
      required -= <property, values>;
    } else {
      for (pre <- prefixes, startsWith(property, pre)) {
        required += <replaceFirst(property, pre, ""), values>;
      }
    }
  }
  for (r <- required) {
    declarations += declaration(r[0], r[1]);
  }
  return ruleSet(selector, declarations);
}