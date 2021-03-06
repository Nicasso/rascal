module lang::css::m3::examples::CodeFromThesis

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

loc location = |home:///workspace/Rascal/rascal/testCSS/examples/vendor.css|;
Declaration stylesheetAST = createAstFromFile(location);
M3 stylesheetM3 = createM3FromFile(location);

void ga() {
	iprintln(stylesheetAST);
}

void go() {
	//iprintln("Important: <importantChecker(stylesheetAST)>");
	//iprintln("Comments: <calculateLinesOfComments(location)>");
	//iprintln("Blank: <blank(location)>");
	//iprintln("Code: <code(location,stylesheetM3)>");
	//iprintln("Comments2: <comment(stylesheetM3)>");
	//
	//iprintln("RL: <ruleLength(stylesheetM3)>");
	//iprintln("NORB: <numberOfRuleBlocks(stylesheetM3)>");
	//iprintln("NOADPRB: <numberOfAttributesDefinedPerRuleBlock(stylesheetM3)>");
	//iprintln("NOCRB: <numberOfCohesiveRuleBlocks(stylesheetM3)>");
	//
	//iprintln("Specificity: <specificity(stylesheetAST)>");
	//
	//iprintln("Avoid IDs: <avoidIds(stylesheetAST)>");
	//
	//iprintln("Vendor prefix fallback:");
	//vendorPrefixFallback(stylesheetAST);
	
	iprintln("Refactor vendor prefix fallback");
	prettyPrint(vendorPrefixFallbackRefactor(stylesheetAST));
}

list[loc] importantChecker(Declaration stylesheetAST) = [d@src | /d:declaration(str property, list[Type] values) := stylesheetAST, d@important?];

int calculateLinesOfComments(loc style) {
  int comment = 0;
  bool commentBlock = false;
  for (line <- readFileLines(style)) {
    if (contains(line,"/*") && !contains(line,"*/")) { 
      commentBlock = true;
      comment += 1;
    } else if (commentBlock && contains(line,"*/")) { 
      commentBlock = false;
      comment += 1;
    } else if (contains(line,"/*") && contains(line,"*/") || commentBlock) {
      comment += 1;
    }
  }
  return comment; 
}

int blank(loc stylesheet) = size([0 | line <- readFileLines(stylesheet), trim(line) == ""]); 
int comment(M3 stylesheetM3) = sum([0]+[size(readFileLines(d[1])) | d <- stylesheetM3@documentation]);
int code(loc style, M3 stylesheetM3) = (size(readFileLines(style))-blank(style)-comment(stylesheetM3)); 

int ruleLength(M3 stylesheetM3) { 
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

int numberOfRuleBlocks(M3 stylesheetM3) = size(ruleSets(stylesheetM3));

real numberOfAttributesDefinedPerRuleBlock(M3 stylesheetM3) = toReal(size(declarations(stylesheetM3)))/size(ruleSets(stylesheetM3));

int numberOfCohesiveRuleBlocks(M3 stylesheetM3) = size([rule | rule <- ruleSets(stylesheetM3), size({a | <e,a> <- stylesheetM3@containment, e == rule, isDeclaration(a)}) == 1]);

list[str] specificity(Declaration stylesheetAST) { 
  int a = 0;
  int b = 0;
  int c = 0;
  list[str] result = [];
  bottom-up visit (stylesheetAST) {
    case combinedSelector(list[Expression] selectors): {
      result += "<a><b><c>";
      a = 0;
      b = 0;
      c = 0;
    }
    case class(str name): {
      b += 1;
    }
    case id(str name): {
      a += 1;
    }
    case domElement(str name): {
      if (name != "*") {
        c += 1;
      }
    }
    case attributeSelector(str attribute, str op, str \value): {
      b += 1;
    }
    case attributeSelector(str attribute): {
      b += 1;
    }
    case pseudoClass(str class): {
      b += 1;
    }
    case pseudoElement(str elem): {
      c += 1;
    }
  };
  return result;
}

list[str] avoidIds(stylesheetAST) = ["ID selector used at: <i@src>" | /i:id(str name) := stylesheetAST];

void vendorPrefixFallback(Declaration stylesheetAST) {
  list[str] prefixes = ["-moz-","-webkit-","-o-","-ms-"];
  set[str] required = {};
  bottom-up visit (stylesheetAST) {
    case rs:ruleSet(list[Expression] selector, list[Statement] Statements): {
      if (size(required) > 0) {
        for (r <- required) {
          println("The <r> property has not been provided as a fallback at: <rs@src>");
        }
      }
      required = {};
    }
    case declaration(str property, list[Type] values): {
      if (property in required) {
        required -= property;
      } else {
        for (pre <- prefixes, startsWith(property, pre)) {
          required += replaceFirst(property, pre, "");
        }
      }
    }
  };
}

Declaration vendorPrefixFallbackRefactor(Declaration stylesheetAST) {
  return visit (stylesheetAST) {
    case ruleSet(list[Expression] selector, list[Statement] declarations) => vendorPrefixFallbackRefactorHelper(selector, declarations)
  };
}

Declaration vendorPrefixFallbackRefactorHelper(list[Expression] selector, list[Statement] declarations) {
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
  if (size(required) > 0) {
    for (r <- required) {
      declarations += declaration(r[0], r[1]);
    }
  }
  return ruleSet(selector, declarations);
}