class DeleteObjectSample
  attr_reader :id, :at, :size
  
  def initialize(id, at, size)
    @id = id
    @at = at
    @size = size
  end

  @@time = /^\s+time: (\d+)$/
  @@id = /^\s+id: (\d+)$/
  @@size = /^\s+size: (\d+)$/

  def self.parse(text)
    DeleteObjectSample.new \
      @@id.match(text)[1].to_i,
      @@time.match(text)[1].to_i,
      @@size.match(text)[1].to_i
  end
  
end