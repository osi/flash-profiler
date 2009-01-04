class GraphView < NSView
  attr_accessor :data_source

  SecondTick = 10

  def initWithFrame(frame) 
    super
    
    @value_path = NSBezierPath.bezierPath
    @value_path.lineWidth = 2.0
    @value_path.lineJoinStyle = NSRoundLineJoinStyle

    @grid_path = NSBezierPath.bezierPath
    @grid_path.lineWidth = 0.5
    @grid_path.setLineDash([2, 10], count: 2, phase: 0)

    @values = []
    
    @path_height = nil
    
    @needs_redraw = false
    
    self
  end
  
  def drawRect(rect)
    NSColor.blackColor.set
    NSBezierPath.fillRect rect

    if self.bounds.size.height != @path_height or @needs_redraw
      redraw
    end
    
    NSColor.grayColor.set
    @grid_path.stroke
    
    NSColor.greenColor.set
    @value_path.stroke
  end
  
  def reloadData
    @values = data_source.valuesForGraphView(self)
    
    if @values.length * SecondTick > frame.size.width
      self.frameSize = NSSize.new(@values.length * SecondTick, frame.size.height)
    end

    @needs_redraw = true
    self.needsDisplay = true
  end
  
  private
  
  def redraw
    @path_height = self.bounds.size.height
    @needs_redraw = false
    
    redraw_grid
    redraw_path
  end
  
  def redraw_grid
    @grid_path.removeAllPoints
    
    (self.bounds.size.width / SecondTick).floor.times do |i|
      x = ((i + 1) * SecondTick) + self.bounds.origin.x
      @grid_path.moveToPoint NSPoint.new(x, 0)
      @grid_path.lineToPoint NSPoint.new(x, self.bounds.origin.y + self.bounds.size.height)
    end
  end
  
  def redraw_path
    @value_path.removeAllPoints
    
    if @values.empty?
      return
    end

    y_mapper = new_y_mapper
    current_x = self.bounds.origin.x
    
    @value_path.moveToPoint NSPoint.new(current_x, y_mapper.call(@values[0]))
    
    @values[1..-1].each do |usage|
      # TODO map them into seconds..
      @value_path.lineToPoint NSPoint.new(current_x += SecondTick, y_mapper.call(usage))
    end
  end
  
  def new_y_mapper
    y = self.bounds.origin.y + 2.5
    min = @values.min.usage
    ratio = (@path_height - 5) / (@values.max.usage - min)
    
    return proc do |usage|
      (usage.usage - min) * ratio + y
    end
  end
end