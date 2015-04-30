import ceylon.io.buffer { ByteBuffer }
// import java.lang { JavaString = String }
import ceylon.collection {  LinkedList, HashMap}
import ceylon.logging { ... }
import ceylon.io.charset {
	ascii
}
"""
   I promise clean the code, the comments temporally act as tips and tricks.
   """

shared Logger log = logger(`module org.kaltia.sheriff`);

//Character string = '+';
//Character array = '*';
//Character bulkstring = '$';
//Character integer = ':';
//Character fail = '-';



HashMap<Character,Types>  idenTypes = HashMap<Character,Types> { 
	'+' -> String,
	'*' -> Array<RTypes>,
	'$' -> String,
	':' -> Integer,
	'-' -> Fail
};


"Given a ByteBuffer convert to String"
by("Miguel Gordian")
String buildString(ByteBuffer res){
	variable String msg = "";
	for(char in res){
		if (char == '\r' || char == '\n' || char == 0.byte ){return msg;}
		msg += char.string;  
		log.info("Charater ``char``");
	} 
	return msg;
}

"This function take 3 parameters according to command structure in redis-cli"
String buildCommand(variable String cmd, Key? k, RTypes[]? values) { 		
	if (is Key k ){
		cmd = cmd + " " + k.string; 
	} 
	if (is RTypes[] values) {
		for (elem in values) {
			cmd = cmd+" "+elem.string;
		} 
	}
	return cmd; 
}


//shared {String*} consume(String s) {
"Return an Array with strings  divided by  newlines  character  
 and remove the tabular characters"
by("Miguel Gordian")
shared String[] consume(String s) {
	String temp = s.replace("\r", "");
	value p = temp.split((Character p) =>  p == '\n');

	if (p != []) {
			variable String[] rlis = [];
		
			for (i in p ){
				if (i != "") {rlis = [i, *rlis];}
				
			}
			return rlis.reversed;
	}
	return [];
}

"Identify data types"
by("zoek")
shared Types identifyType(String data){
	
	if (exists tmp=data[0], exists t=idenTypes.get(tmp)) {
		return t;
	}
	return String;
}

"Build an Array with tokens [type, data]"
by("zoek")
shared [Types,RTypes] buildToken(String s){
	value type = identifyType(s);
	if (type is Integer(Integer)) {
		if (exists n=parseInteger(String(s.sublistFrom(1)))) {
			return [type, n];
		}
	} if (type is Array<RTypes>({RTypes*})) {
		if (exists n=parseInteger(String(s.sublistFrom(1)))) {
			return [type, n];
		}
	}
	
	return [String, String(s.sublistFrom(1))];
}

shared [Types,String][] buildTokens(String s) {
	variable [Types,String][] tokCommand  = [[Integer, "$564"]];
	
	for (i in consume(s)){
		value type = identifyType(i);
		tokCommand = [[type, String(i.sublistFrom(1))],*tokCommand];
	} 
	
	return tokCommand;
}

RTypes consumeData(String s) {
	return s;
}

RTypes consumeError(String s) {
	return s;
}		

RTypes parseResponse(String s) {
	if (is Character status=s[0], status in idenTypes.keys) {
			return consumeData(s);
	}
	
	return consumeError(s);

}