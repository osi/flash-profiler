class NewObjectSample < BaseSample
  attr_reader :id, :type, :source
  
  @@id = /^\s+id: (\d+)$/
  @@type = /^\s+type: ([\w.:]+)$/
  
  def initialize(text, session_start, offset)
    super
    
    @id = @@id.match(text)[1].to_i
    @type = @@type.match(text)[1]
    @source = StackFrame.parse(text)
  end
end
