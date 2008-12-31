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
  
  def hash
    @class_name.hash ^ @method_name.hash ^ file.hash ^ line.hash
  end
  
  def ==(other)
    return false if not other.is_a? StackFrame
    
    class_name == other.class_name and 
    method_name == other.method_name and 
    file == other.file and 
    line == other.line
  end

  def eql?(other)
    self == other
  end
  
  def equal?(other)
    self == other
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