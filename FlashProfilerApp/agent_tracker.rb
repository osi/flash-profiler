class AvailableAgentsTracker
  attr_accessor :table
  
  def initialize
    @agents = []
    @semaphore = Mutex.new
  end
  
  def add(agent)
    @semaphore.synchronize { @agents.push(agent) }
    
    NSLog "Need to update table from main thread"
    
    @table.performSelectorOnMainThread :reloadData, :withObject => nil, :waitUntilDone => false
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
  
end