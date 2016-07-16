module experiments::Compiler::Examples::REPL

import  experiments::Compiler::Execute;
import util::SystemAPI;
import IO;
import util::IDE;
import Exception;
import Message;

loc makeTMP(){
	tmpdir = getSystemProperty("java.io.tmpdir");
	test_modules = |file:///| + tmpdir + "/test-modules";
	if(!exists(test_modules)){
		mkDirectory(test_modules);
	}
   
	mloc = |test-modules:///TMP.rsc|;
   return mloc;
}

value run(str exp, bool debug=false, bool recompile=true, bool profile=false) {
    msrc = "module experiments::Compiler::Tests::TMP  value main() = <exp>;";
    TMP = makeTMP();
	writeFile(TMP, msrc);
	
	return execute(TMP, [], debug=debug, recompile=recompile, profile=profile);
}	

void main(){
	createConsole("Compiled Rascal Console",
	              "Welcome to the first (but stupid) Compiled Rascal Console",
	              str (str inp) {
	                try {
	              		v = run(inp);
	              		println("v = <v>");
	              		return "<v>";
	              	} catch Exception e:
	              		return "<e>";
	              	  catch msgs:
	              	  	return "<msgs>";
	              });
	
}