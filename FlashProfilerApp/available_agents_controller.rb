class AvailableAgentsController
  attr_accessor :sessions, :table, :tracker
  
  def connect(sender)
    row = @table.selectedRow
    
    if row >= 0
      agent = tracker.agent_at(row)
      
      session = ProfilingSession.alloc.initWithAgent(agent)
      
      sessions.addDocument(session)
      
      session.makeWindowControllers
      session.showWindows
    end
    
# it then sends the new document makeWindowControllers and showWindows messages.    
  end
end