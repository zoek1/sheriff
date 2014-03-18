import ceylon.io { ... }
import ceylon.io.charset { ascii }
import ceylon.io.buffer { newByteBuffer }

shared alias Server => String;
shared alias Port => Integer;

interface Status {
	formal shared String event;
	string => event;
}

class Ok(shared actual String event) satisfies Status {}
class Fail(shared actual String event) satisfies Status {}


class FailConnectServer(String? msg, Exception? cause) 
		extends Exception(msg, cause){
}

class Redis(Server server = "127.0.0.1", Port port = 6379) {
	value connector = newSocketConnector(SocketAddress(server, port));
	
	variable Socket? redis = null;
	
	try {
		print("Conexion a redis aceptada!");
		redis = connector.connect();

	} catch (e){
		throw FailConnectServer(e.message, e.cause);
	}
	
	"""# Peticion al servidor
	   
	   Si la conexion con el servidor se interrumpio se genera
	   una excepcion y si la variable redis mantiene un valor de Null 
	   en vez de Socket nada se ejecuta.
	   """
	throws (`class FailConnectServer`, "Se interrumpio la conexion con el servidor")
	Integer send(String msg) {
		if (is Socket credis = redis){
			try {
				value enc_msg = ascii.encode(msg + "\r\n"); 
				Integer len = credis.write(enc_msg);
				return len;
			} catch (e) {
				throw FailConnectServer(e.message, e.cause);
			}
		}
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
		if (is Socket credis = redis) {
			try {
				value len = credis.read(res);
			} catch (e) {
				throw FailConnectServer(e.message, e.cause);
			}
		}
		return buildString(res);
	}
	
	
	shared String exec(String cmd){
		value slen = send(cmd);
		return recv();
	}
	
	shared Anything() close => void() { 
		if (is Socket credis = redis) {
			credis.close();
		}
	};
}