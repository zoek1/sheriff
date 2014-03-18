shared String identity(String command) => command;

shared class Repl(shared String(String) eval=identity, 
		   shared String prompt = "$") {
	"""# Inicio de Repl
	   Genera un ciclo en el cual lee, evalue, e imprime hasta
	   que se de una entrada que coincida con la condicion de paro.
	"""
	by("Miguel Angel Gordian <os.aioria@gmail.com")
	shared void loop(String end=""){
		while(true) {
			process.write("``prompt`` "); 
			value read = process.readLine();
			if (read == end){return;}
			print(eval(read));
		}
	}
}