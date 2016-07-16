module experiments::Compiler::Tests::VIO

import IO;
import ValueIO;
import Type;

void main(){
  l = |std:///experiments/Compiler/Tests/XXX|;
  v = #int;
  writeTextValueFile(l, v);
  w = readTextValueFile(type(\value(), #Symbol.definitions), l);
  println("<typeOf(v)> v = <v>, <typeOf(w)>  w = <w>");
}