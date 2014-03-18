import ceylon.test { ... }

class Repl_Test() {
/*	
	shared beforeTest void pre() {
		print("** Test de Repl - Starting");
	}
	shared afterTest void post() {
		
	}
*/
	shared test void identity_test () {
		assert(identity("ok") == "ok");
	}
	
	shared test void repl_prompt_test (){
		value repl = Repl {prompt = "=>";};
		assert(repl.prompt == "=>");
	}
	
	shared test ignore void repl_function_identity_test () {		
		value repl = Repl();
		print(repl.eval);
		print(identity);
		assert(identity == identity); 
	}
}
