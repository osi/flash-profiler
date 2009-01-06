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
    # url = NSURL.fileURLWithPath "~/Desktop/test two.profiler-session-data".stringByExpandingTildeInPath
    # url = NSURL.fileURLWithPath "~/Desktop/modo2.profiler-session-data".stringByExpandingTildeInPath
    # sessions.openDocumentWithContentsOfURL url, display: true, error: nil

    # FIXME don't be evil and grab focus for testing
    # NSApplication.sharedApplication.activateIgnoringOtherApps true
    
    listener = Listener.new(tracker)

    io_thread = IoThread.alloc.initWithListener(listener)
    io_thread.start
    
    # @thread = Thread.new do
    #   run = true
    # 
    #   NSLog "Starting io thread"
    # 
    #   listener.start
    # 
    #   NSLog "Started listener"
    # 
    #   run_loop = NSRunLoop.currentRunLoop
    # 
    #   STDERR.puts "#{run_loop}"
    # 
    #   begin
    #     while run and run_loop.runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture)
    #       # NSLog "run..."
    #       # do nothing!
    #     end
    #   rescue Exception => e
    #     NSLog "Failure in run loop #{e}"
    #   end
    #   
    # 
    #   NSLog "io thread exiting.."      
    # end
  end
end