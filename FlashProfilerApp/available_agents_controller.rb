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
  
  def awakeFromNib
    # FIXME remove the below once done testing
    url = NSURL.fileURLWithPath "~/Desktop/test two.profiler-session-data".stringByExpandingTildeInPath
    sessions.openDocumentWithContentsOfURL url, display: true, error: nil

    # FIXME don't be evil and grab focus for testing
    NSApplication.sharedApplication.activateIgnoringOtherApps true
  end
end