import org.kaltia.repl { Repl }
"Run the module `org.kaltia.sheriff`."
shared void run() {
	try {
    	value redis = Redis();
    	value repl = Repl(redis.execloop);
    	repl.loop();
    	redis.close();
	}catch (FailConnectServer e){
		print("No se puede conectar con el servidor de redis!");
	} finally {
		print("Ciao!");
	}
}