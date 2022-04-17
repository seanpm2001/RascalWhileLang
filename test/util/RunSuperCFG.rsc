module util::RunSuperCFG




import vis::Render;
import vis::Figure; 
import IO;
import Relation;
import util::Math;
import analysis::graphs::LabeledGraph;
import lang::\while::ifds::SuperCFGProgram;
import lang::\while::ifds::SuperCFG;
import lang::\while::SuperCFGUtil;
import lang::\while::interprocedural::InterproceduralSyntax;

public void main(){ 
	superCFG();
}

public void superCFG(){
	WhileProgram p = superCFGProgram();
	renderSuperCFG(p);
}