package {
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.DataEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.XMLSocket;

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
    	}
    	
    	private function connect():void {
    	    trace(PREFIX, "Trying to connect to", _host, ":", _port);
    	    
    	    try {
    	        _socket.connect(_host, _port);
	        } catch (e:Error) {
	            trace(PREFIX, "Unable to connect ", e);
	        }
    	}
    	
    	private function connected(e:Event):void {
    	   _connected = true;

    	   trace(PREFIX, "Connected");

    	   _socket.send("AGENT READY");
    	}
    	
    	private function close(e:Event):void {
    	   _connected = false;
    	   trace(PREFIX, "Disconnected, will try to reconnect");
    	   
           connect();
    	}

    	private function fail(e:Event):void {
            trace(PREFIX, "Communication failure", e);
    	}
    }
}

