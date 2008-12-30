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
    m = send_and_expect "GET MEMORY", /MEMORY: (\d+) (\d+)/
    
    MemoryUsage.new m[1].to_i, m[2].to_i
  end
  
  def samples
    count = send_and_expect("GET SAMPLES", /SENDING SAMPLES: (\d+)/)[1].to_i
    samples = []
    
    count.times do
      samples.push read_sample
    end
    
    samples
  end
  
  def start_sampling
    @started_at = send_and_expect("START SAMPLING", /OK START (\d+)/)[1].to_i
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
    :started == @sampling_state
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
   
    case expected
    when Regexp
      m = expected.match(response)
      return m if m != nil
    when response
      return response
    end
    
    raise "Invalid response: #{response}"
  end
  
  def send_message(msg) 
    @socket.write("#{msg}\x00")
  end
  
  def read_message
    # TODO this will throw Errno::ECONNRESET when the flash side terminates
    # Odd that I can't 'chop' off the null
    @socket.readline("\x00").unpack("Z*")[0]
  end  
end