framework 'AsyncSocket'

class Listener
  attr_accessor :host, :port
  
  def initialize(tracker)
    @host = "127.0.0.1"
    @port = 42624
    
    @tracker = tracker
    
    @socket = AsyncSocket.alloc.initWithDelegate(self)
  end
  
  def start
    # error_pointer = Pointer.new_with_type("@")

    if not @socket.acceptOnAddress(@host, port: @port, error: nil) # pass error_pointer
      NSLog "Unable to open socket"
      # error_pointer[0]
    else
      s = "Started server at " + host + ":" + port.to_s
      # FIXME using #{} bails here..
      NSLog s.to_s
    end
  end
  
  # AsyncSocket delgates

  def onSocket(socket, didAcceptNewSocket:newSocket)
    NSLog "will make agent.."

    Agent.new newSocket, tracker
  end

  def onSocket(socket, willDisconnectWithError:err)
    NSLog "Listener closing due to #{err}"
  end
end
