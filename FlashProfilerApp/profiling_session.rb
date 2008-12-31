class ProfilingSession < NSDocument
  attr_accessor :agent, :memory_usage

  def init
    super
    
    @memory_usage = []
  end

  def initWithAgent(agent)
    init
    
    @agent = agent
    
    self
  end
  
  def add_sample_set(samples)
    
  end
  
  
  # NSDocument overrides

  def windowNibName
    # Implement this to return a nib to load OR implement
    # -makeWindowControllers to manually create your controllers.
    return "ProfilingSession"
  end

end
