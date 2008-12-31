class ProfilingSessionController
  attr_accessor :session, :collect_button, :memory_usage

  def initialize
    @memory_usage = []
  end
  
  def awakeFromNib
    @agent = @session.agent
    
    if not @agent.nil?
      @timer = NSTimer.scheduledTimerWithTimeInterval 1, 
        target: self, 
        selector: :get_memory_usage, 
        userInfo: nil, 
        repeats: true
    end
  end
  
  def get_memory_usage
    usage = @agent.memory_usage
    
    @session.memory_usage.push usage
    
    NSLog "#{usage}"
  end
  
  def collect_button_action(sender)
    if @agent.sampling?
      @agent.pause_sampling
      
      samples = @agent.samples
      
      @agent.stop_sampling

      @session.add_sample_set samples
    else
      @agent.start_sampling
    end
  end
  
  # NSToolbar Delegate
  
  def validateToolbarItem(item)
    if item == @collect_button
      if @agent.nil?
        @collect_button.label = "Not Connected" 
      elsif @agent.sampling?
        @collect_button.label = "Stop"
      else
        @collect_button.label = "Collect"
      end
      
      not @agent.nil?
    else
      true
    end
  end
  
end