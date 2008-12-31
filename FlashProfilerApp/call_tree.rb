class CallTree
  attr_reader :root
  
  def initialize
    @root = Node.new StackFrame.new("<root>", "")
  end
  
  def <<(sample)
    current_node = root
    
    sample.stack.reverse_each do |frame|
      if current_node.has_child? frame
        current_node = current_node.child_for(frame)
        current_node.visits += 1
      else
        current_node = current_node.add_child(Node.new(frame))
      end
    end
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
  end
end