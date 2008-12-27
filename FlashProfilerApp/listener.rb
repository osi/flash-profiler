require "socket"

class Listener
  attr_accessor :host, :port, :tracker
  
  def start
    NSLog "Starting server at #{@host}:#{@port}"
    
    server = TCPServer.new(@host, @port)
    
    @thread = Thread.new do
      NSLog "waiting for connection"

      while true do
        begin
          @tracker.add Agent.new(server.accept)
        rescue Exception => e
          NSLog "#{e.to_s}"

          e.backtrace.each { |l| NSLog "#{l}" }
          
          retry
        end
      end
    end
  end
  
  def awakeFromNib
    # TODO these should come from prefs

    @host = "localhost"
    @port = 42624

    start
  end
end
