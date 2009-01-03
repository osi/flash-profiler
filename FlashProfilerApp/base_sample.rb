class BaseSample
  attr_reader :at, :raw_time
  
  @@time = /^\s+time: (\d+)$/
  
  def initialize(text, session_start, offset)
    @raw_time = @@time.match(text)[1].to_i
    
    if offset.nil?
      @at = session_start
    else
      begin
        @at = Time.at session_start.sec, session_start.usec + @raw_time - offset
      rescue RangeError => e
        NSLog "ERROR: invalid time. session started at #{session_start}, offset is #{offset} and current raw value is #{@raw_time}"
      end
    end
  end
  
  # NSCoding
  
  def initWithCoder(coder)
    @raw_time = coder.decodeObjectForKey("raw").to_i
    @at = Time.at coder.decodeInt64ForKey("at_sec"), coder.decodeInt64ForKey("at_usec")
    
    self
  end
  
  def encodeWithCoder(coder)
    coder.encodeInt64 at.sec, forKey: "at_sec"
    coder.encodeInt64 at.usec, forKey: "at_usec"
    coder.encodeObject raw_time.to_s, forKey: "raw"
  end
  
end