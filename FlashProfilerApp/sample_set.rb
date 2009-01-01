class SampleSet
  attr_reader :cpu, :objects, :call_tree
  
  def initialize
    @call_tree = CallTree.new
    @cpu = []
    @objects = []
    @objects_by_id = Hash.new
  end
  
  def <<(sample)
    case sample
    when CpuSample
      @cpu << sample
      @call_tree << sample
    when NewObjectSample
      @objects << sample
      @objects_by_id[sample.id] = sample
    when DeleteObjectSample
      @objects << sample
      new_object = @objects_by_id[sample.id]
      
      if not new_object.nil?
        new_object.deleted = sample
        sample.created = new_object
      end
    end
  end
  
  # NSCoding
  
  def initWithCoder(coder)
    @cpu = coder.decodeObjectForKey("cpu")
    @objects = coder.decodeObjectForKey("objects")
    @objects_by_id = coder.decodeObjectForKey("objects_by_id")
    @call_tree = coder.decodeObjectForKey("call_tree")
    
    self
  end
  
  def encodeWithCoder(coder)
    coder.encodeObject cpu, forKey: "cpu"
    coder.encodeObject objects, forKey: "objects"
    coder.encodeObject call_tree, forKey: "call_tree"
    coder.encodeObject @objects_by_id, forKey: "objects_by_id"
  end
end