class StackFrame
  attr_reader :class_name, :method_name, :file, :line
  
  @@lines = /\n  stack: (?:\n    (.+))+/m
  @@frame = /^(.+)\/(.+)\((.+)?\:?(\d+)?\)$/
  
  def initialize(class_name, method_name, file = nil, line = nil)
    @class_name = class_name
    @method_name = method_name
    @file = file
    @line = line
  end
  
  def self.parse(text)
    frames = @@lines.match(text)
    
    if frames.nil?
      return nil
    end
    
    frames[1].split("\n").map { |s| s.strip }.map do |frame|
      m = @@frame.match(frame)
      StackFrame.new m[1], m[2], m[3], m[4] ? m[4].to_i : nil
    end
  end
  
  
end