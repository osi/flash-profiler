class DeleteObjectSample < BaseSample
  attr_reader :id, :size
  attr_accessor :created
  
  @@id = /^\s+id: (\d+)$/
  @@size = /^\s+size: (\d+)$/
  
  def initialize(text, session_start, offset)
    super

    @id = @@id.match(text)[1].to_i
    @size = @@size.match(text)[1].to_i
  end

  # NSCoding
  
  def initWithCoder(coder)
    super
    
    @id = coder.decodeIntegerForKey("id")
    @size = coder.decodeIntegerForKey("size")
    @created = coder.decodeObjectForKey("created")
    
    self
  end
  
  def encodeWithCoder(coder)
    super
    
    coder.encodeInteger id, forKey: "id"
    coder.encodeInteger size, forKey: "size"
    coder.encodeObject created, forKey: "created"
  end

end