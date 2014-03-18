import ceylon.io.buffer { ByteBuffer }

String buildString(ByteBuffer res){
	variable String msg = "";
	for(char in res.bytes()){
		if (char == '\r' || char == 0 ){break;}
		msg += char.character.string;  
	} 
	return msg;
}