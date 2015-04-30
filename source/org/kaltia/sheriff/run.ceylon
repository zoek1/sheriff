import org.kaltia.repl { Repl }
import ceylon.logging {
	debug,
	trace
}
"Run the module `org.kaltia.sheriff`."
shared void run() {
	try {
    	value redis = Redis { server = "172.17.0.2"; priority=trace; };
    	value repl = Repl(redis.execloop);
    	repl.loop();
    	redis.close();
	}catch (FailConnectServer e){
		log.error("No se puede conectar con el servidor de redis!");
	} finally {
		log.info("Ciao!");
	}
}