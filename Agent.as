package {
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.DataEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.Socket;
    import flash.system.System;
    import flash.utils.getTimer;
    import flash.utils.Timer;
    import flash.utils.getQualifiedClassName;
    import flash.sampler.*;

    public class Agent extends Sprite {
	    private static const HOST:String = "localhost";
	    private static const PORT:int = 42624;
	    private static const PREFIX:String = "[AGENT]";
	    
	    private var _host:String;
	    private var _port:int;
	    private var _socket:Socket;
	    private var _connected:Boolean;
	    private var _sampleSender:Timer;
	
    	public function Agent() {
    	    trace(PREFIX, "Loaded");
    	    
    	    _host = loaderInfo.parameters["host"] || HOST;
    	    _port = loaderInfo.parameters["port"] || PORT;
	    
	        _socket = new Socket();

            _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, fail);
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, dataReceived);
            _socket.addEventListener(Event.CONNECT, connected);
            _socket.addEventListener(Event.CLOSE, close);

            connect();
    	}
    	
    	private function dataReceived(e:ProgressEvent):void {
    	    if( _socket.bytesAvailable < 2 ) {
    	        // All commands are two-bytes.
    	        return;
    	    }
    	    
    	    var command:uint = _socket.readUnsignedShort();
    	    
    	    trace(PREFIX, "Received command", command);    	   
    	    
    	    switch( command ) {
                case 0x4202:
                    _socket.writeShort(0x4203);
                    _socket.writeUnsignedInt(getTimer());
                    _socket.writeUnsignedInt(System.totalMemory);
                    _socket.flush();
                    return;
                    
//                case "START SAMPLING":
//                    startSampling();
//                    _socket.send("OK START " + new Date().time );
//                    return;
//                    
//                case "PAUSE SAMPLING":
//                    pauseSampling();
//                    _socket.send("OK PAUSE");
//                    return;
//                    
//                case "STOP SAMPLING":
//                    stopSampling();
//                    _socket.send("OK STOP");
//                    return;
//                    
//                case "GET SAMPLES":
//                    var count:int = getSampleCount();
//                    
//                    trace(PREFIX, "Sending", count, "samples");
//
//                    _socket.send("SENDING SAMPLES: " + count);
//                    
//                    var samples:Array = []
//                    
//                    for each (var s:Sample in getSamples()) {
//                        samples.push(s);
//                    }
//                    
//                    var batchSize:int = 1000;
//                    var offset:int = 0;
//                    
//                    _sampleSender = new Timer(100, Math.ceil(count / batchSize) );
//                    _sampleSender.addEventListener(TimerEvent.TIMER, function(e:Event):void {
//                        var toSend:int = Math.min(count, offset + batchSize);
//                        
//                        trace(PREFIX, "Sending", offset, "-", toSend);
//                        
//                        for( var i:int = offset; i < toSend; i++ ) {
//                            _socket.send(sampleToString(samples[i]));
//                            
//                            if( i % 100 == 0) {
//                                trace(PREFIX, "Sent", i, "/", toSend);
//                            }
//                        }
//                        
//                        offset += batchSize;
//                    });
//                    _sampleSender.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:Event):void {
//                        trace(PREFIX, "Done sending samples");
//
//                        _sampleSender = null;
//                    });
//                    _sampleSender.start();
//                    
//                    return;
//                    
//                case "CLEAR SAMPLES":
//                    clearSamples();
//                    
//                    _socket.send("OK CLEARED");
//                    return;
                    
                default:
                    _socket.writeShort(0x4200);
                    _socket.writeUTF("UNKNOWN COMMAND");
                    _socket.flush();
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
           
           var now:Number = new Date().getTime();
           var seconds:uint = now / 1000;
           var timer:uint = getTimer();

           _socket.writeShort(0x4201);
           _socket.writeUnsignedInt(seconds);
           _socket.writeShort(now - (seconds * 1000));
           _socket.writeUnsignedInt(timer);
           _socket.flush();
           
           trace(PREFIX, now, seconds, now - (seconds * 1000), timer);
    	}
    	
    	private function close(e:Event):void {
    	   _connected = false;

    	   trace(PREFIX, "Disconnected");
    	}

    	private function fail(e:Event):void {
            trace(PREFIX, "Communication failure", e);

    	    _socket.close();
    	    _connected = false;
    	}
    }
}

