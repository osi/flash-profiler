class CallTree
  attr_reader :root
  
  def initialize
    @root = Node.new StackFrame.new("<root>", "")
    @root.visits = 0
  end
  
  def <<(sample)
    current_node = root
    current_node.visits += 1
    
    sample.stack.reverse_each do |frame|
      if current_node.has_child? frame
        current_node = current_node.child_for(frame)
        current_node.visits += 1
      else
        current_node = current_node.add_child(Node.new(frame))
      end
    end
  end
  
  def to_s
    root.to_s 0, root.visits.to_f
  end
  
  # NSCoding
  
  def initWithCoder(coder)
    @root = coder.decodeObjectForKey("root")
    
    self
  end
  
  def encodeWithCoder(coder)
    coder.encodeObject root, forKey: "root"
  end  
  
  # TODO need to handle cycles in the tree
  class Node
    attr_reader :frame, :children
    attr_accessor :visits
    
    def initialize(frame)
      @frame = frame
      @children = []
      @visits = 1
    end
    
    def has_child?(frame)
      children.any? { |child| child.frame == frame }
    end
    
    def child_for(frame)
      children.find { |child| child.frame == frame }
    end
    
    def add_child(node)
      children << node
      node
    end
    
    def to_s(level, total_visits)
      "  " * level << 
      (visits / total_visits * 100).round.to_s << 
      " " <<
      frame.to_s << 
      children.map { |child| "\n" << child.to_s(level+1, total_visits) }.join
    end
    
    # NSCoding

    def initWithCoder(coder)
      @frame = coder.decodeObjectForKey("frame")
      @children = coder.decodeObjectForKey("children")
      @visits = coder.decodeIntegerForKey("visits")

      self
    end

    def encodeWithCoder(coder)
      coder.encodeObject frame, forKey: "frame"
      coder.encodeObject children, forKey: "children"
      coder.encodeInteger visits, forKey: "visits"
    end    
  end
end