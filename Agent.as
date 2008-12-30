package {
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.DataEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.XMLSocket;
    import flash.system.System;
    import flash.utils.getTimer;
    import flash.utils.getQualifiedClassName;
    import flash.sampler.*;

    public class Agent extends Sprite {
	    private static const HOST:String = "localhost";
	    private static const PORT:int = 42624;
	    private static const PREFIX:String = "[AGENT]";
	    
	    private var _host:String;
	    private var _port:int;
	    private var _socket:XMLSocket;
	    private var _connected:Boolean;
	
    	public function Agent() {
    	    trace(PREFIX, "Loaded");
    	    
    	    _host = loaderInfo.parameters["host"] || HOST;
    	    _port = loaderInfo.parameters["port"] || PORT;
	    
	        _socket = new XMLSocket();

            _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, fail);
            _socket.addEventListener(DataEvent.DATA, dataReceived);
            _socket.addEventListener(Event.CONNECT, connected);
            _socket.addEventListener(Event.CLOSE, close);

            connect();
    	}
    	
    	private function dataReceived(e:DataEvent):void {
    	    trace(PREFIX, "Received command", e.data);    	   
    	    
    	    switch( e.data ) {
                case "GET MEMORY":
                    _socket.send("MEMORY: " + new Date().time + " " + System.totalMemory);
                    return;
                    
                case "START SAMPLING":
                    startSampling();
                    _socket.send("OK START " + new Date().time );
                    return;
                    
                case "PAUSE SAMPLING":
                    pauseSampling();
                    _socket.send("OK PAUSE");
                    return;
                    
                case "STOP SAMPLING":
                    stopSampling();
                    _socket.send("OK STOP");
                    return;
                    
                case "GET SAMPLES":
                    trace(PREFIX, "Sending", getSampleCount(), "samples");

                    _socket.send("SENDING SAMPLES: " + getSampleCount());
                    
                    for each (var s:Sample in getSamples()) {
                        _socket.send(sampleToString(s));
                    }
                    
                    trace(PREFIX, "Done sending samples");
                    
                    return;
                    
                case "CLEAR SAMPLES":
                    clearSamples();
                    
                    _socket.send("OK CLEARED");
                    return;
                    
                default:
                    _socket.send("UNKNOWN COMMAND");
                    return;
    	    }
    	}
    	
    	private function sampleToString(s:Sample):String {
            if( s is NewObjectSample ) {
                var nos:NewObjectSample = s as NewObjectSample;
                
                return "[NewObjectSample" +
                    "\n   time: " + nos.time +
                    "\n     id: " + nos.id +
                    "\n   type: " + getQualifiedClassName(nos.type) +
                    stackToString(nos.stack) +
                    "\n]";
                    
            } else if( s is DeleteObjectSample ) {
                var dos:DeleteObjectSample = s as DeleteObjectSample;
                
                return "[DeleteObjectSample" +
                    "\n   time: " + dos.time +
                    "\n     id: " + dos.id +
                    "\n   size: " + dos.size +
                    stackToString(dos.stack) +
                    "\n]";
            }

            return "[Sample" +
                "\n   time: " + s.time +
                stackToString(s.stack) +
                "\n]";
    	}
    	
    	private function stackToString(stack:Array):String {
    	    if( null == stack ) {
    	        return "";
    	    }
    	    
    	    var separator:String = "\n    ";
    	    return "\n  stack: " + separator + stack.join(separator);
    	}
    	
    	private function connect():void {
    	    trace(PREFIX, "Trying to connect to", _host, ":", _port);
    	    
    	    try {
    	        _socket.connect(_host, _port);
	        } catch (e:Error) {
	            trace(PREFIX, "Unable to connect", e);
	        }
    	}
    	
    	private function connected(e:Event):void {
    	   _connected = true;

    	   trace(PREFIX, "Connected");

    	   _socket.send("AGENT READY");
    	}
    	
    	private function close(e:Event):void {
    	   _connected = false;

    	   trace(PREFIX, "Disconnected");
    	}

    	private function fail(e:Event):void {
    	    _socket.close();
    	    _connected = false;
            trace(PREFIX, "Communication failure", e);
    	}
    }
}

