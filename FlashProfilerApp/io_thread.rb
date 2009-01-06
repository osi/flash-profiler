class IoThread < NSThread
  attr_accessor :run

  def initWithListener(listener)
    init
    
    @listener = listener
    @run = true
    
    self
  end

  def main
    NSLog "Starting IoThread"

    @listener.start

    NSLog "Started listener"

    run_loop = NSRunLoop.currentRunLoop

    begin
      while run and run_loop.runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture)
        # NSLog "run..."
        # do nothing!
      end
    rescue Exception => e
      NSLog "Failure in run loop #{e}"
    end

    NSLog "io thread exiting.."      
  end
  
end