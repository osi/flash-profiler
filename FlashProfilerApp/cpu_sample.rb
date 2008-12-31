class CpuSample < BaseSample
  attr_reader :stack
  
  def initialize(text, session_start, offset)
    super
    @stack = StackFrame.parse(text)
  end
  
end