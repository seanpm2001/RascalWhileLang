module lang::\while::CFG

import lang::\while::Syntax; 

import analysis::graphs::Graph;


alias CFG = Graph[Label];

//returns the initial label of a statement
/*public Label init(Stmt s) {
  	switch(s) {
    	case Assignment(_, _, l): return l;
    	case Skip(l): return l;
    	case Seq(s1, _): return init(s1);
    	case IfThenElse(Condition(_, l), _, _): return l; 
    	case While(Condition(_, l), _): return l; 
  	};
  	return 0;
} 
*/
public Label init(Assignment(_, _, l)) = l;
public Label init(Skip(l)) = l;
public Label init(Seq(s1, _)) = init(s1);
public Label init(IfThenElse(Condition(_, l), _, _)) = l;
public Label init(While(Condition(_, l), _)) = l;


@doc{
.Synopsis
Returns the set of final labels in a statement.

.Description
Whereas a sequence of statements has a single entry, it may ha ve multiple exits (as for example in the conditional).
}
/*
public set[Label] final(Stmt s){
	switch(s) {
    	case Assignment(_, _, l): return { l };
    	case Skip(l): return { l };
    	case Seq(_, s2): return final(s2);
    	case IfThenElse(_, s1, s2): return final(s1) + final(s2); 
    	case While(Condition(_, l), _): return { l }; 
  	};
	return{};
}
*/
public set[Label] final(Assignment(_, _, l)) = { l };
public set[Label] final(Skip(l)) = { l };
public set[Label] final(Seq(_, s2)) = final(s2);
public set[Label] final(IfThenElse(_, s1, s2)) = final(s1) + final(s2);
public set[Label] final(While(Condition(_, l), _)) = { l };

//return the set of statements, or elementary blocks, of the form of: assignments, skip or conditions
/*public set[Block] blocks(Stmt s) {
  	switch(s) {
    	case Assignment(_, _, _): return { stmt(s) };
    	case Skip(_): return { stmt(s) };
    	case Seq(s1, s2): return blocks(s1) + blocks(s2);
    	case IfThenElse(c, s1 , s2): return { condition(c) } + blocks(s1) + blocks(s2); 
    	case While(c, s1): return { condition(c) } + blocks(s1); 
  	}
  	return {}; 
}*/
public set[Block] blocks(s: Assignment(_, _, _)) = { stmt(s) };
public set[Block] blocks(s: Skip(_)) = { stmt(s) };
public set[Block] blocks(Seq(s1, s2)) = blocks(s1) + blocks(s2);
public set[Block] blocks(IfThenElse(c, s1 , s2)) = { condition(c) } + blocks(s1) + blocks(s2);
public set[Block] blocks(While(c, s1)) = { condition(c) } + blocks(s1);
public set[Block] blocks(WhileProgram p) = blocks(p.s);

public set[Label] labels(Stmt s) = { label(b) | Block b <- blocks(s) };

public CFG flow(Stmt s) {
	switch(s) {
    	case Assignment(_, _, _): return { };
    	case Skip(_): return { };
    	case Seq(s1, s2): return flow(s1) + flow(s2) + {<l,init(s2)> | Label l <- final(s1)};
    	case IfThenElse(Condition(_, l), s1, s2): return flow(s1) + flow(s2) + <l,init(s1)> + <l, init(s2)>;
    	case While(Condition(_, l), s1): return flow(s1) + <l,init(s1)> + {<l2,l> | Label l2 <- final(s1)};
  	};
	return {};
}

public CFG flow(WhileProgram p){
	return flow(p.s);
}

public CFG reverseFlow(Stmt s){
	return {<to,from> | <from,to> <- flow(s)};
}

public CFG reverseFlow(CFG cfg){
	return {<to,from> | <from,to> <- cfg};
}

public CFG reverseFlow(WhileProgram p){
	return reverseFlow(flow(p));
}
