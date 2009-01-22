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
    import flash.utils.ByteArray;
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

        private var _baseTime:Number;
	    private var _samplingStarted:Number;
	
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
                case 0x4204:
                    startSampling();
                    _samplingStarted = new Date().getTime() * 1000;
                    _socket.writeShort(0x4205);
                    _socket.flush();
                    return;
                case 0x4206:
                    pauseSampling();
                    _socket.writeShort(0x4207);
                    _socket.flush();
                    return;
                case 0x4208:
                    stopSampling();
                    _socket.writeShort(0x4209);
                    _socket.flush();
                    return;
                case 0x420a:
                    var count:int = getSampleCount();

                    trace(PREFIX, "Sending", count, "samples");
                    
                    _socket.writeShort(0x420b);
                    _socket.writeUnsignedInt(count);
                    _socket.flush();
                    
                    var samples:Array = []
               
                    for each (var s:Sample in getSamples()) {
                        samples.push(s);
                    }
                    
                    var sampleTimeOffset:Number = _samplingStarted - samples[0].time;
                    var batchSize:int = 1000;
                    var offset:int = 0;
                   
                    _sampleSender = new Timer(100, Math.ceil(count / batchSize) );
                    _sampleSender.addEventListener(TimerEvent.TIMER, function(e:Event):void {
                        var toSend:int = Math.min(count, offset + batchSize);
                       
                        trace(PREFIX, "Sending", offset, "-", toSend);
                        
                        for( var i:int = offset; i < toSend; i++ ) {
                            _socket.writeBytes(encodeSample(samples[i], sampleTimeOffset));
                           
                            if( i % 100 == 0) {
                                trace(PREFIX, "Sent", i, "/", toSend);
                            }
                        }
                        
                        _socket.flush();
                       
                        offset += batchSize;
                    });
                    _sampleSender.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:Event):void {
                        trace(PREFIX, "Done sending samples");

                        _sampleSender = null;
                    });
                    _sampleSender.start();
                   
                    return;
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
    	
    	private function encodeSample(s:Sample, sampleTimeOffset:Number):ByteArray {
    	    var out:ByteArray = new ByteArray();
    	    var time:Number = _baseTime * 1000 + (s.time - sampleTimeOffset);
    	    
            if( s is NewObjectSample ) {
                var nos:NewObjectSample = s as NewObjectSample;
            
                out.writeShort(0x4210);
                out.writeUnsignedInt(time);
                out.writeUnsignedInt(nos.id);
                out.writeUTF(getQualifiedClassName(nos.type));
                
            } else if( s is DeleteObjectSample ) {
                var dos:DeleteObjectSample = s as DeleteObjectSample;
                
                out.writeShort(0x4211);
                out.writeUnsignedInt(time);
                out.writeUnsignedInt(dos.id);
                out.writeUnsignedInt(dos.size);
                
            } else {
                out.writeShort(0x4212);
                out.writeUnsignedInt(time);
            } 
            
            var stack:Array = s.stack;
            
            if( null == stack ) {
                out.writeShort(0);
            } else {
                out.writeShort(stack.length);

                for each( var frame:StackFrame in stack ) {
                    out.writeUTF(frame.name);
                    
                    if( frame.file == null ) {
                        out.writeShort(0);
                    } else {
                        out.writeUTF(frame.file);
                        out.writeUnsignedInt(frame.line);
                    }
                }
            }
            
            return out;
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
           
           _baseTime = new Date().getTime();
           var seconds:uint = _baseTime / 1000;
           var timer:uint = getTimer();

           _socket.writeShort(0x4201);
           _socket.writeUnsignedInt(seconds);
           _socket.writeShort(_baseTime - (seconds * 1000));
           _socket.writeUnsignedInt(timer);
           _socket.flush();
           
           trace(PREFIX, _baseTime, seconds, _baseTime - (seconds * 1000), timer);
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

