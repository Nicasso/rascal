module lang::css::m3::AST

extend analysis::m3::AST;

import util::FileSystem;
import lang::css::m3::TypeSymbol;
import IO;
import Set;
import String;
import List;

data Declaration
    = declaration(Expression property, Expression \value, Modifier modifier)
    ;

data Expression 
    = selector(Type \type, Expression expression)
    | property(Type \type, list[Expression] dimensions)
    | \value(Type \type, list[Expression] dimensions)
    | string(str \value)
    ;

data Statement
    = ruleSet(list[Expression] selectors, list[Declaration] declarations)
    | ruleMedia(Expression mediaQueries, Statement \value)
    | ruleFontFace(Statement \value)
    | ruleImport(Type uri)
    | ruleMargin(Expression atRule, Statement \value)
    | rulePage(Expression atRule, Statement \value)
    | ruleViewport(Expression atRule, Statement \value)
    ;

data Type 
    = class()
    | id()
    | domElement()
    | property()
    | angle()
    | color()
    | expression()
    | frequency()
    | function()
    | ident()
    | integer()
    | length()
    | percent()
    | \list()
    | number()
    | numeric()
    | pair()
    | percent()
    | resolution()
    | string()
    | time()
    | uri()
    ;

data Modifier
    = important()
    ;