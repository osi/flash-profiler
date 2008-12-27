class AvailableAgentsTracker
  attr_accessor :table
  
  def initialize
    @agents = []
    @semaphore = Mutex.new
  end
  
  def add(agent)
    @semaphore.synchronize { @agents.push(agent) }
    
    refresh_view
  end
  
  def agent_at(index)
    agent = @semaphore.synchronize { @agents.slice!(index) }
    
    refresh_view
    
    agent
  end
  
  def remove(agent)
    
  end
  
  # NSTableView delegate methods
  
  def numberOfRowsInTableView(view)
    @semaphore.synchronize { @agents.size }
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    @semaphore.synchronize { @agents[index].to_s }
  end
  
  private
  
  def refresh_view
    @table.performSelectorOnMainThread :reloadData, :withObject => nil, :waitUntilDone => false
  end
  
end