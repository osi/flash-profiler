class BaseSample
  attr_reader :at, :raw_time
  
  @@time = /^\s+time: (\d+)$/
  
  def initialize(text, session_start, offset)
    @raw_time = @@time.match(text)[1].to_i
    
    if nil == offset
      @at = session_start
    else
      @at = Time.at session_start.sec, session_start.usec + @raw_time - offset
    end
  end
end