import ceylon.io { ... }
import ceylon.io.charset { ascii }
import ceylon.io.buffer { newByteBuffer,
	ByteBuffer }
import ceylon.logging {
	addLogWriter,
	Priority,
	warn
}
import ceylon.language.meta.declaration {
	Module,
	Package
}


shared class Redis(Server server = "127.0.0.1", 
		Port port = 6379, 
		Priority priority = warn) satisfies Connection {
	
	addLogWriter {
		void log(Priority p, Module|Package c, String m, Exception? e) {
			value print = p<=priority
			then process.writeLine 
			else process.writeError;
			if (exists e) {
				printStackTrace(e, print);
			}
		}
	};
	
	value connector = newSocketConnector(SocketAddress(server, port));
	
	variable Socket? redis = null;
	
	try {
		redis = connector.connect();
		log.info("The connection was stablished with the server!");
	} catch (e){
		log.error("The connection can't being stablished");
		throw FailConnectServer(e.message, e);
	}
	
	"""# Peticion al servidor
	   
	   Si la conexion con el servidor se interrumpio se genera
	   una excepcion y si la variable redis mantiene un valor de Null 
	   en vez de Socket nada se ejecuta.
	   """
	throws (`class FailConnectServer`, "Se interrumpio la conexion con el servidor")
	Integer send(String msg) {
		log.info("send: sending data");
		if (is Socket credis = redis){
			try {
				log.info("Verify connection with the server");
				
				value enc_msg = ascii.encode(msg + "\r\n"); 
				Integer len = credis.write(enc_msg);
				log.info("Sending encoded data (``ascii.encode(msg)``, ``len``)");
				
				return len;
			} catch (e) {
				log.error("The connection is broken");
				throw FailConnectServer(e.message, e);
			} 
		}
	
		log.info("The conection doesn't exists");
			
	return 0;
	}
	
	"""# Respuesta del servidor
	   
	   Si la conexion con el servidor se interrumpio se genera
	   una excepcion y si redis mantiene un valor de null
	   no se ejecuta nada.
   	"""
	throws (`class FailConnectServer`, "Se interrumpio la conexion con el servidor")
	String recv() {
		value res = newByteBuffer(120);
		value decoder = ascii.Decoder();
		log.info("reciving data");
		variable value len = 0;
		if (is Socket credis = redis) {
			try {
				
				//credis.readFully(void (ByteBuffer buffer) {decoder.decode(buffer);});
				len = credis.read(res);
				res.flip();
				log.info("reading data (``res.take(len)``), ``res.writable``");
			} catch (e) {
				log.error("Can't be get a response, 'cause the connection is broken");
				throw FailConnectServer(e.message, e);
			}
		}
		res.flip();
		return ascii.decode(res);
		
		// return decoder.consume();
	}
	
	
	shared actual RTypes exec(variable String cmd, Key? k, [RTypes]? values ){
		cmd = buildCommand(cmd, k, values);
		log.info("Command generated ``cmd``");
		
		send(cmd);
		return parseResponse(recv());
	}
	
	shared String execloop(String s) {
		log.info("loop: Sendig data ``s``");
		send(s);
		if (s.lowercased == "quit") {
			log.info("Exit");
			return "";
		}
		log.info("loop: reciving data");
		value res = parseResponse(recv()).string;
		if (!res.empty) { return res; }
		return "OK";
	}
	
	shared Anything() close => void() {
		log.info("close the connection"); 
		if (is Socket credis = redis) {
			credis.close();
		}
	};
}