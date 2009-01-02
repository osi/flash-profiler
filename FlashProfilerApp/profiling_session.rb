class ProfilingSession < NSDocument
  attr_accessor :agent, :memory_usage, :sample_sets, :cpu_view

  def init
    super
    
    @memory_usage = []
    @sample_sets = []
    @viewing_sample_set = nil
    
    self
  end

  def initWithAgent(agent)
    init
    
    @agent = agent
    
    self
  end
  
  def add_sample_set(set)
    @sample_sets << set
    
    updateChangeCount NSChangeDone
  end
  
  
  # NSDocument overrides

  def windowNibName
    # Implement this to return a nib to load OR implement
    # -makeWindowControllers to manually create your controllers.
    return "ProfilingSession"
  end
  
  def dataOfType(typeName, error:outError)
    NSKeyedArchiver.archivedDataWithRootObject [memory_usage, sample_sets]
  end
  
  def readFromData(data, ofType:typeName, error:outError)
    stored = NSKeyedUnarchiver.unarchiveObjectWithData data
    @memory_usage = stored[0]
    @sample_sets = stored[1]
    # TODO outError is a Pointer instance.
    # error = NSError.errorWithDomain NSOSStatusErrorDomain, code: -4, userInfo: nil
    true
  end
  
  def awakeFromNib
    formatter = NSNumberFormatter.alloc.init
    formatter.numberStyle = NSNumberFormatterPercentStyle
    
    @cpu_view.tableColumnWithIdentifier("time").dataCell.formatter = formatter
  end
  
  def windowControllerDidLoadNib(controller)
    # TODO replace with an actual selection
    @viewing_sample_set = sample_sets[0]
    @cpu_view.reloadData
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
