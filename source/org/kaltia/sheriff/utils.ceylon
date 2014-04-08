import ceylon.io.buffer { ByteBuffer }
// import java.lang { JavaString = String }
import ceylon.collection {  LinkedList, HashMap}

"""
   I promise clean the code, the comments temporally act as tips and tricks.
   """


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
	for(char in res.bytes()){
		if (char == '\r' || char == 0 ){break;}
		msg += char.character.string;  
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
			// Curiosamente esto no devuelve todos los elementos solo los que se definieron cuando se creo
//			if (exists String first = p.first){
//			 LinkedList<String> n= LinkedList<String>({first});
//		
//			for (i in p) { 
//				print("Valor en lista : ``i``");
//				if  ( i != ""){
//					print("Agregando : ``i``");
//					n.add(i);
//				}
//			
//			 n.remove(n.size -1);
//
//			return {*n};
//		}
// }
			variable String[] rlis = [];
		
			for (i in p ){
				if (i != "") {rlis = [i, *rlis];}
				
			}
			return rlis.reversed;
			
			//variable String[] rlis = [*p];
			
			//if (rlis.size > 1){
			//	rlis = rlis.trim { function trimming(String elem) => elem == ""; };
			//}
			//return rlis;
		
			
	}
	return [];
}

"Identify data types"
by("zoek")
shared Types identifyType(String data){
	//if (exists tmp = data[0], tmp == integer){
	//	return Integer;
	//} else if  (exists tmp = data[0], tmp == array) {
	//	return Array<RTypes>;
	//}
	
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
		if (exists n=parseInteger(String(s.skipping(1)))) {
			return [type, n];
		}
	} if (type is Array<RTypes>({RTypes*})) {
		if (exists n=parseInteger(String(s.skipping(1)))) {
			return [type, n];
		}
	}
	
	return [String, String(s.skipping(1))];
}

shared [Types,String][] buildTokens(String s) {
	variable [Types,String][] tokCommand  = [[Integer, "$564"]];
	
	//value cmd = buildData(":");
	//if (is Integer(Integer) cmd ) {
	//	value test = cmd(5);
	//	print("Integer  ``test``");
	//}
	for (i in consume(s)){
		value type = identifyType(i);
		tokCommand = [[type, String(i.skipping(1))],*tokCommand];
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