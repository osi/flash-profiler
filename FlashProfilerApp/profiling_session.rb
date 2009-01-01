class ProfilingSession < NSDocument
  attr_accessor :agent, :memory_usage, :sample_sets

  def init
    super
    
    @memory_usage = []
    @sample_sets = []
    
    self
  end

  def initWithAgent(agent)
    init
    
    @agent = agent
    
    self
  end
  
  def add_sample_set(set)
    @sample_sets << set
  end
  
  
  # NSDocument overrides

  def windowNibName
    # Implement this to return a nib to load OR implement
    # -makeWindowControllers to manually create your controllers.
    return "ProfilingSession"
  end
  
  def dataOfType(typeName, error:outError)
    NSKeyedArchiver.archivedDataWithRootObject [memory_usage, sample_sets]
  end
  
  def readFromData(data, ofType:typeName, error:outError)
    stored = NSKeyedUnarchiver.unarchiveObjectWithData data
    @memory_usage = stored[0]
    @sample_sets = stored[1]
    # error = NSError.errorWithDomain NSOSStatusErrorDomain, code: -4, userInfo: nil
    true
  end
  
end
