class AvailableAgent
  attr_reader :name, :host, :port
  
  def initialize(name, host, port)
    @name = name
    @host = host
    @port = port
  end
end

class AvailableAgentsDataSource
  
  def initialize
    @agents = []
    
    @agents.push AvailableAgent.new("test", "localhost", "4242")
  end
  
  def numberOfRowsInTableView(view)
    @agents.size
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    @agents[index].send(column.identifier)
  end
  
end