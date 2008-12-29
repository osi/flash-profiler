class Agent
  def initialize(socket)
    NSLog "Accepted connection from #{socket.peeraddr[2]}:#{socket.peeraddr[1]}"

    @socket = socket
    
    hello_msg = read_message
    
    if "AGENT READY" != hello_msg
      socket.close

      raise "Invalid hello message #{hello_msg}"
    end
    
    @sampling_state = :stopped
    
    NSLog "Agent ready"
  end
  
  def memory_usage
    send_message "GET MEMORY"
    
    response = read_message
    
    if response =~ /MEMORY: (\d+) (\d+)/
      MemoryUsage.new $1.to_i, $2.to_i
    else
      raise "Invalid response to memory request #{response}"
    end
  end
  
  def samples
    send_message "GET SAMPLES"
    
    response = read_message

    if response =~ /SENDING SAMPLES: (\d+)/
      samples = []
      
      $1.to_i.times do
        samples.push read_sample
      end
      
      samples
    else
      raise "Invalid response to sample retrieval #{response}"
    end
  end
  
  def start_sampling
    send_and_expect "START SAMPLING", "OK START"
    
    @sampling_state = :started
  end
  
  def pause_sampling
    send_and_expect "PAUSE SAMPLING", "OK PAUSE"
    
    @sampling_state = :paused
  end
  
  def stop_sampling
    send_and_expect "STOP SAMPLING", "OK STOP"
    
    @sampling_state = :stopped
  end
  
  def sampling?
    :started == sampling_state
  end
  
  def to_s
    "#{@socket.peeraddr[2]}:#{@socket.peeraddr[1]}"
  end
  
  private
  
  def read_sample
    data = read_message
    
    STDERR.puts data
  end
  
  def send_and_expect(msg, expected)
    send_message msg
    
    response = read_message
  
    if expected != response
      raise "Invalid ack: #{response}"
    end    
  end
  
  def send_message(msg) 
    @socket.write("#{msg}\x00")
  end
  
  def read_message
    # TODO this will throw Errno::ECONNRESET when the flash side terminates
    # Odd that I can't 'chop' off the null
    @socket.readline("\x00").unpack("Z*")[0]
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