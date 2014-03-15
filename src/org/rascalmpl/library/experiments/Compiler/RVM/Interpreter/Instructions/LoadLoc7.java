package org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.Instructions;

import org.rascalmpl.library.experiments.Compiler.RVM.Interpreter.CodeBlock;


public class LoadLoc7 extends Instruction {

	public LoadLoc7(CodeBlock ins){
		super(ins, Opcode.LOADLOC7);
	}
	public void generate(){
		System.out.println("LOADLOC7");
		codeblock.addCode0(opcode.getOpcode());
	}
}
