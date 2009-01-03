class MemoryUsage
  include Comparable
  
  attr_reader :at, :usage
  
  def initialize(at, usage)
    @at = Time.at(at / 1000, at % 1000 * 1000)
    @usage = usage
  end
  
  def to_s
    "MemoryUsage[usage=#{usage}, at=#{at}]"
  end
  
  def <=>(other)
    self.usage <=> other.usage
  end
  
  # NSCoding
  
  def initWithCoder(coder)
    @at = Time.at coder.decodeInt64ForKey("at_sec"), coder.decodeInt64ForKey("at_usec")
    @usage = coder.decodeInt64ForKey("usage")
    
    self
  end
  
  def encodeWithCoder(coder)
    coder.encodeInt64 at.sec, forKey: "at_sec"
    coder.encodeInt64 at.usec, forKey: "at_usec"
    coder.encodeInt64 usage, forKey: "usage"
  end  
  
end