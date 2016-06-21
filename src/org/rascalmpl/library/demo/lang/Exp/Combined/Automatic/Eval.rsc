// tag::module[]
module demo::lang::Exp::Combined::Automatic::Eval

import demo::lang::Exp::Abstract::Syntax;
import demo::lang::Exp::Abstract::Eval;
import demo::lang::Exp::Combined::Automatic::Load;

int eval(str txt) = eval(load(txt));
// end::module[]

test bool tstEval1() = eval("7") == 7;
test bool tstEval2() = eval("7*3") == 21;
test bool tstEval3() = eval("7+3") == 10;
test bool tstEval3() = eval("3+4*5") == 23;
