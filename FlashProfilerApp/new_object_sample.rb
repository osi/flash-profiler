class NewObjectSample
  attr_reader :id, :at, :type, :source
  
  @@time = /^\s+time: (\d+)$/
  @@id = /^\s+id: (\d+)$/
  @@type = /^\s+type: ([\w.:]+)$/
  
  def initialize(id, at, type, source)
    @id = id
    @at = at
    @type = type
    @source = source
  end
  
  def self.parse(text)
    NewObjectSample.new \
      @@id.match(text)[1].to_i,
      @@time.match(text)[1].to_i,
      @@type.match(text)[1],
      StackFrame.parse(text)
  end
  
end
