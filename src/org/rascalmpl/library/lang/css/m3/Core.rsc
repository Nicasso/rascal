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

@memo
set[loc] getPaths(loc dir, str suffix) { 
   bool containsFile(loc d) = isDirectory(d) ? (x <- d.ls && x.extension == suffix) : false;
   return find(dir, containsFile);
}

public M3 composeCSSM3(loc id, set[M3] models) {
  m = composeM3(id, models);
  
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
    
    if (size(sourcePaths) == 0) {
    	throw "<project> contains no .css files.";
    }
    
    M3 result = composeCSSM3(project, createM3sFromFiles({p | sp <- sourcePaths, p <- find(sp, "css"), isFile(p)}));
    registerProject(project, result);
    return result;
}

public M3 createM3FromFiles(loc projectName, set[loc] files)
    = composeCSSM3(projectName, createM3sFromFiles(files));

@javaClass{org.rascalmpl.library.lang.css.m3.internal.m3.M3Loader}
@reflect
public java set[M3] createM3sFromFiles(set[loc] files);
    
@javaClass{org.rascalmpl.library.lang.css.m3.internal.m3.M3Loader}
@reflect
public java M3 createM3FromString(str source, loc file = |unknown:///|);

public bool isStyleSheet(loc entity) = entity.scheme == "css+stylesheet";
public bool isId(loc entity) = entity.scheme == "css+id";
public bool isClass(loc entity) = entity.scheme == "css+class";
public bool isDeclaration(loc entity) = entity.scheme == "css+declaration";
public bool isSelector(loc entity) = entity.scheme == "css+selector";
public bool isFontFaceRule(loc entity) = entity.scheme == "css+fontfacerule";
public bool isMarginRule(loc entity) = entity.scheme == "css+marginrule";
public bool isNameSpaceRule(loc entity) = entity.scheme == "css+namespacerule";
public bool isCounterStyleRule(loc entity) = entity.scheme == "css+counterstylerule";
public bool isMediaRule(loc entity) = entity.scheme == "css+mediarule";
public bool isPageRule(loc entity) = entity.scheme == "css+pagerule";
public bool isRuleSet(loc entity) = entity.scheme == "css+ruleset";
public bool isViewportRule(loc entity) = entity.scheme == "css+viewportrule";

@memo public set[loc] stylesheets(M3 m) =  {e | <e,_> <- m@declarations, isStyleSheet(e)};
@memo public set[loc] ids(M3 m) =  {e | <_,e> <- m@names, isId(e)};
@memo public set[loc] classes(M3 m) = {e | <_,e> <- m@names, isClass(e)};
@memo public set[loc] declarations(M3 m) = {e | <e,_> <- m@declarations, isDeclaration(e)};
@memo public set[loc] selectors(M3 m) = {e | <e,_> <- m@declarations, isSelector(e)};

@memo public set[loc] fontFaceRules(M3 m) = {e | <e,_> <- m@declarations, isFontFaceRule(e)};
@memo public set[loc] nameSpaceRules(M3 m) = {e | <e,_> <- m@declarations, isNameSpaceRule(e)};
@memo public set[loc] counterStyleRules(M3 m) = {e | <e,_> <- m@declarations, isCounterStyleRule(e)};
@memo public set[loc] marginRules(M3 m) = {e | <e,_> <- m@declarations, isMarginRule(e)};
@memo public set[loc] mediaRules(M3 m) = {e | <e,_> <- m@declarations, isMediaRule(e)};
@memo public set[loc] pageRules(M3 m) = {e | <e,_> <- m@declarations, isPageRule(e)};
@memo public set[loc] ruleSets(M3 m) = {e | <e,_> <- m@declarations, isRuleSet(e)};
@memo public set[loc] viewportRules(M3 m) = {e | <e,_> <- m@declarations, isViewportRule(e)};