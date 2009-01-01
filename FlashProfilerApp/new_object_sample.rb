class NewObjectSample < BaseSample
  attr_reader :id, :type, :source
  attr_accessor :deleted
  
  @@id = /^\s+id: (\d+)$/
  @@type = /^\s+type: ([\w.:]+)$/
  
  def initialize(text, session_start, offset)
    super
    
    @id = @@id.match(text)[1].to_i
    @type = @@type.match(text)[1]
    @source = StackFrame.parse(text)
  end
  
  # NSCoding
  
  def initWithCoder(coder)
    super
    
    @id = coder.decodeIntegerForKey("id")
    @type = coder.decodeObjectForKey("type")
    @source = coder.decodeObjectForKey("source")
    @deleted = coder.decodeObjectForKey("deleted")
    
    self
  end
  
  def encodeWithCoder(coder)
    super
    
    coder.encodeInteger id, forKey: "id"
    coder.encodeObject type, forKey: "type"
    coder.encodeObject source, forKey: "source"
    coder.encodeObject deleted, forKey: "deleted"
  end  
end
