package {
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.DataEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.XMLSocket;

    public class Agent extends Sprite {
        // TODO externalize these into parameters in mm.cfg?
	    private static const HOST:String = "localhost";
	    private static const PORT:int = 42624;
	    private static const PREFIX:String = "[AGENT]";
	    
	    private static var _instance:Agent;
	    private var _socket:XMLSocket;
	    private var _connected:Boolean;
	
    	public function Agent() {
    	    trace(PREFIX, _instance);
    	    
    	    if( null != _instance ) {
    	        trace(PREFIX,"Already loaded, ignoring request");
    	        return;
    	    }
    	    
    	    _instance = this;
    	    
    	    trace(PREFIX,"Loaded", loaderInfo.parameters["host"], loaderInfo.parameters["port"]);
	    
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
    	    trace(PREFIX, "Trying to connect to", HOST, ":", PORT);
    	    
    	    try {
    	        _socket.connect(HOST, PORT);
	        } catch (e:Error) {
	            trace(PREFIX, "Unable to connect ", e);
	        }
    	}
    	
    	private function connected(e:Event):void {
    	   _connected = true;
    	   trace(PREFIX, "Connected");
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

