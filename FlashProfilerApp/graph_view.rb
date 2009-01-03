class GraphView < NSView
  attr_accessor :data_source

  def initWithFrame(frame) 
    super
    
    @value_path = NSBezierPath.bezierPath
    @value_path.lineWidth = 2.0
    @value_path.lineJoinStyle = NSRoundLineJoinStyle

    @values = []
    
    @path_height = nil
    
    self
  end
  
  def drawRect(rect)
    NSColor.blackColor.set
    NSBezierPath.fillRect rect
    
    if not @values.empty?
      if self.bounds.size.height != @path_height
        redraw_path
      end
    
      NSColor.greenColor.set
      @value_path.stroke
    end
  end
  
  def reloadData
    @values = data_source.valuesForGraphView(self)

    self.needsDisplay = true
  end
  
  private
  
  def redraw_path
    @value_path.removeAllPoints
    @path_height = self.bounds.size.height
    
    if @values.empty?
      return
    end
    
    origin = self.bounds.origin
    min = @values.min
    ratio = @path_height / (@values.max.usage - min.usage)
    
    current_x = origin.x
    x_tick = 3
    
    @value_path.moveToPoint NSPoint.new(current_x, (@values[0].usage - min.usage) * ratio + origin.y)
    
    @values[1..-1].each do |usage|
      @value_path.lineToPoint NSPoint.new(current_x += x_tick, (usage.usage - min.usage) * ratio + origin.y)
    end
  end
  
end