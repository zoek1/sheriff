shared interface Connection {
  shared formal RTypes exec(variable String cmd, Key? k, [RTypes]? values);
  
  shared String echo(String msg) {
  	value recv = exec("echo", msg, null);
  	if (is String recv) {
  		return recv; 	
	}
	return "";
  }	
}