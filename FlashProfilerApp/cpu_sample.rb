class CpuSample
  attr_reader :at, :stack
  
  @@time = /^\s+time: (\d+)$/
  
  def initialize(at, stack)
    @at = at
    @stack = stack
  end

  def self.parse(text)
    CpuSample.new \
      @@time.match(text)[1].to_i,
      StackFrame.parse(text)
  end
  
  
end