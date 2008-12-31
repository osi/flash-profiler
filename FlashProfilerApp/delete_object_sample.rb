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

end