class ProfilingSessionController
  attr_accessor :session, :collect_button, :memory_usage

  def initialize
    @memory_usage = []
  end
  
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
    usage = @agent.memory_usage
    
    @memory_usage.push usage
    
    NSLog "#{usage}"
  end
  
  def collect_button_action(sender)
    if @agent.sampling?
      @agent.pause_sampling
      
      samples = @agent.samples
      
      @agent.stop_sampling
    else
      @agent.start_sampling
    end
  end
  
  # NSToolbar Delegate
  
  def validateToolbarItem(item)
    if item == @collect_button
      if nil == @agent
        @collect_button.label = "Not Connected" 
      elsif @agent.sampling?
        @collect_button.label = "Stop"
      else
        @collect_button.label = "Collect"
      end
      
      nil != @agent
    else
      true
    end
  end
  
end