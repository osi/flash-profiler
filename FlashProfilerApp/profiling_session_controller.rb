class ProfilingSessionController
  attr_accessor :session
  attr_accessor :collect_button
  
  def awakeFromNib
    @agent = @session.agent
    
    if nil != @agent
      @timer = NSTimer.scheduledTimerWithTimeInterval 1, 
        target: self, 
        selector: :get_memory_usage, 
        userInfo: nil, 
        repeats: true
    end
  end
  
  def get_memory_usage
    NSLog "#{@agent.memory_usage}"
  end
  
  def collect_button_action(sender)
    NSLog "TODO, start collecting yo"
    # TODO user hit collect button
  end
  
  # NSToolbar Delegate
  
  def validateToolbarItem(item)
    if item == @collect_button
      nil != @agent
    else
      true
    end
  end
  
end