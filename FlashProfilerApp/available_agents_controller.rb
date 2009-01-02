class AvailableAgentsController
  attr_accessor :sessions, :table, :tracker
  
  def connect(sender)
    row = @table.selectedRow
    
    if row >= 0
      agent = tracker.agent_at(row)
      
      NSLog "Will create session for #{agent}"
      
      session = ProfilingSession.alloc.initWithAgent(agent)
      
      sessions.addDocument(session)
      
      session.makeWindowControllers
      session.showWindows
    end
  end
end