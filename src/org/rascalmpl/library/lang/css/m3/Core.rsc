module lang::css::m3::Core

extend lang::css::m3::TypeSymbol;
import lang::css::m3::Registry;
import lang::css::m3::AST;

extend analysis::m3::Core;

import analysis::graphs::Graph;
import analysis::m3::Registry;

import IO;
import ValueIO;
import String;
import Relation;
import Set;
import Map;
import Node;
import List;

import util::FileSystem;

public M3 composeCSSM3(loc id, set[M3] models) {
  m = composeM3(id, models);
  
  m@invocation = {*model@invocation | model <- models};
  m@annotations = {*model@annotations | model <- models};
  
  return m;
}

public M3 createM3FromFile(loc file) {
    result = createM3sFromFiles({file});
    if ({oneResult} := result) {
        return oneResult;
    }
    throw "Unexpected number of M3s returned for <file>";
}

public M3 createM3FromDirectory(loc project) {
    if (!(isDirectory(project))) {
      throw "<project> is not a valid directory";
    }
    
    sourcePaths = getPaths(project, "css");
    M3 result = composeCSSM3(project, createM3sFromFiles({p | sp <- sourcePaths, p <- find(sp, "css"), isFile(p)}));
    registerProject(project, result);
    return result;
}

public M3 createM3FromFiles(set[loc] files)
    = composeCSSM3(projectName, createM3sFromFiles(files));

@javaClass{org.rascalmpl.library.lang.css.m3.internal.m3.M3Loader}
@reflect
public java set[M3] createM3sFromFiles(set[loc] files);
    
@javaClass{org.rascalmpl.library.lang.css.m3.internal.m3.M3Loader}
@reflect
public java M3 createM3FromString(str source, loc file = |unknown:///|);