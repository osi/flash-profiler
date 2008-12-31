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
end