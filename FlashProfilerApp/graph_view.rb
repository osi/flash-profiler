class GraphView < NSView

  def drawRect(rect)
    NSLog "asked to draw #{rect}"
    
    # NSColor.whiteColor.set
    # NSBezierPath.fillRect rect
  end
  
end