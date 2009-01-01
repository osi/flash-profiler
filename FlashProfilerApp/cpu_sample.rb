class CpuSample < BaseSample
  attr_reader :stack
  
  def initialize(text, session_start, offset)
    super
    @stack = StackFrame.parse(text)
  end

  # NSCoding
  
  def initWithCoder(coder)
    super
    
    @stack = coder.decodeObjectForKey("stack")
    
    self
  end
  
  def encodeWithCoder(coder)
    super
    
    coder.encodeObject stack, forKey: "stack"
  end
  
  
end