class Agent
  def initialize(socket)
    puts "Accepted connection from #{socket.peeraddr[2]}:#{socket.peeraddr[1]}"

    @socket = socket
    
    hello_msg = read_message
    
    if "AGENT READY" != hello_msg
      raise "Invalid hello message #{hello_msg}"
    end
    
    puts "Agent ready"
  end
  
  def read_message
    @socket.readline("\x00").chop
  end
  
  # Write +string+ to the host.
  #
  # Does not perform any conversions on +string+.  Will log +string+ to the
  # dumplog, if the Dump_log option is set.
  # def write(string)
  #   length = string.length
  #   while 0 < length
  #     IO::select(nil, [@sock])
  #     @dumplog.log_dump('>', string[-length..-1]) if @options.has_key?("Dump_log")
  #     length -= @sock.syswrite(string[-length..-1])
  #   end
  # end  
end