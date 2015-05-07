import ceylon.test { ... }
import org.kaltia.sheriff { ... }
import ceylon.logging {
	warn
}


class ConsumeTest() {
	 
	shared test void test_consume () {
		assertEquals(consume("Hola mundo\n"), ["Hola mundo"]);
	}

	shared test void test_consume_without_newline () {
		assertEquals(consume("Hola mundo"), ["Hola mundo"]);
	}
 
 	shared test void test_consume_with_redis_cmd() {	
 		assertEquals(consume("*2\r\n$3\r\nfoo\r\n$3\r\nbar\r\n"), ["*2","$3", "foo", "$3", "bar"]);
 	}
 	
 	shared test void test_consume_with_null_element () {
 		assertEquals(consume("*3\r\n$3\r\nfoo\r\n$-1\r\n$3\r\nbar\r\n"), ["*3","$3","foo","$-1","$3","bar"]);
 	}
 	
 	shared test void test_consume_empty_string () {
 		assertEquals(consume(""), []);
 	}
 	
 	shared test void test_consume_newlineandr_string () {
 		assertEquals(consume("\r\n"), []);
 	}
 	
 	shared test void test_consume_error_string () {
 		assertEquals(consume("-WRONGTYPE Operation against a key holding the wrong kind of value"), 
 			["-WRONGTYPE Operation against a key holding the wrong kind of value"]);
 	}
}

class IdentifyTypeTest () {
	shared test void test_identify_string() {
		assertTrue(identifyType("+Mi cadena") is String({Character*}));
	}
	
	shared test void test_identify_integer() {
		assertTrue(identifyType(":345") is Integer(Integer));
	}
	
	shared test void test_indentify_array() {
		assertTrue(identifyType("*3") is Array<RTypes>({RTypes*}));
	} 
}

class BuildToken (){
	shared test void test_build_string() {
		value  res = buildToken("+Cadena");	
		assertTrue(res[0] is String({Character*}) );
		assertEquals("Cadena", res[1]);
	}
	
	shared test void test_build_integer () {
		value res = buildToken(":546");
		
		assertTrue(res[0] is Integer(Integer));
		
		if(res[1] is Integer ) {
			assertEquals(546, res[1]);
		}
		
		assertEquals(546, res[1]);
	}
	
	shared test void test_build_array () {
		value res = buildToken("*5");
		assertTrue(res[0] is Array<RTypes>({RTypes*}));
		assertEquals(res[1], 5);
	}
}


class ServerCommands() {
	value redis = Redis { server = "127.0.0.1"; priority=warn; };
	
	shared test void test_echo_command (){
		assertEquals(redis.echo("sheriff"), "sheriff");
	}
	
	shared test void test_ping_fail_command () {
		value redis = Redis { server = "127.0.0.1"; priority=warn; };
		redis.close();
		assertEquals(redis.ping(), null);
	}
	
	shared test void test_ping_ok_command () {
		assertEquals(redis.ping(), "PONG");
	}
}