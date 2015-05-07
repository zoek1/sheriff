shared interface Connection {
  //TODO: Add metadata maybe return a new object with its metadata
  shared formal RTypes exec(variable String cmd, Key? k, [RTypes]? values);
  
  shared String echo(String msg) {
  	value recv = exec("echo", msg, null);
  	if (is String recv) {
  		return recv; 	
	}
	return "";
  }	
  
  shared String? ping() {
  	try {
  		value recv = exec("ping", null, null);
  		if (is String recv) {
  			if (recv == "") { return "PONG"; }
  		}
  		print(recv);

  	} catch (e){  	
  		return null;
	}

  	return null;
  }
}