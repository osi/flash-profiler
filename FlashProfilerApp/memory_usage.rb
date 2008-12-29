class MemoryUsage
  attr_reader :at, :usage
  
  def initialize(at, usage)
    @at = Time.at(at / 1000, at % 1000 * 1000)
    @usage = usage
  end
  
  def to_s
    "MemoryUsage[usage=#{usage}, at=#{at}]"
  end
  
end