class ProfilingSessionController < NSWindowController
  attr_accessor :collect_button, :memory_graph, :cpu_view

  def awakeFromNib
    @viewing_sample_set = nil
    @agent = document.agent
    
    if not @agent.nil?
      @timer = NSTimer.scheduledTimerWithTimeInterval 1, 
        target: self, 
        selector: :get_memory_usage, 
        userInfo: nil, 
        repeats: true
    end
    
    formatter = NSNumberFormatter.alloc.init
    formatter.numberStyle = NSNumberFormatterPercentStyle
    
    @cpu_view.tableColumnWithIdentifier("time").dataCell.formatter = formatter
    
    if not document.sample_sets.empty?
      self.viewing_sample_set = document.sample_sets[0]
    end
  end
  
  def get_memory_usage
    usage = @agent.memory_usage
    
    document.memory_usage.push usage
    document.updateChangeCount NSChangeDone
    
    NSLog "#{usage}"
  end
  
  def collect_button_action(sender)
    if @agent.sampling?
      @agent.pause_sampling
      
      samples = @agent.samples
      
      @agent.stop_sampling

      document.add_sample_set samples
    else
      @agent.start_sampling
    end
  end
  
  # FIXME temporary code since set-on-load
  def viewing_sample_set=(set)
    @viewing_sample_set = set
    @cpu_view.reloadData
  end
  
  def windowControllerDidLoadNib(controller)
    NSLog "did load nib... in controller"
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
  
  # NSOutlineView delegates
  
  def outlineView(view, numberOfChildrenOfItem:item)
    if @viewing_sample_set.nil?
      0
    else
      current_or_root(item).children.length
    end
  end
  
  def outlineView(view, isItemExpandable:item)
    current_or_root(item).children.length > 0
  end
  
  def outlineView(view, child:child, ofItem:item)
    current_or_root(item).children[child]
  end
  
  def outlineView(view, objectValueForTableColumn:column, byItem:item)
    case column.identifier
    when "location"
      "#{item.frame.class_name}/#{item.frame.method_name}"
    when "time"
      item.time
    end
  end
  
  private
  
  def current_or_root(item)
    item.nil? ? @viewing_sample_set.call_tree.root : item
  end  
  
end