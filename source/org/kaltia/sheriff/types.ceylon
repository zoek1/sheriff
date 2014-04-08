shared alias ZSet => Set<Float>;

shared alias Key => String; 

shared alias RString => Integer|Float|String;

shared alias RSequence => Array<RString>|Set<RString>|ZSet|{<Key -> RString>*};

shared alias RTypes => RString|RSequence;

shared interface Status {
	formal shared String event;
	string => event;
}

shared class Ok(shared actual String event) satisfies Status {}
shared class Fail(shared actual String event) satisfies Status {}

shared alias Server => String;
shared alias Port => Integer;


shared class FailConnectServer(String? msg, Exception? cause) 
		extends Exception(msg, cause){
}

shared alias Types => Array<RTypes>({RTypes*})|String({Character*})|Integer(Integer)|Fail(String);

class Op<E>(Status(Key, E) operation, Key id, E values) {
	
}

Op<RString> set (String key, RString argument) {
	return Op<RString>((Key k, RString y) => Ok("``k``: ``y``"), key, argument);
}