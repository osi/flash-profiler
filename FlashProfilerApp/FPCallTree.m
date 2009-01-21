//
//  FPCallTree.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/8/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPCallTree.h"


@implementation FPCallTree

@synthesize root = _root;

- (id)init {
    [super init];
    
    _root = [[FPCallTreeNode alloc] initWithStackFrame:[[FPStackFrame alloc] initWithClassName:@"<root>" methodName:@""]];
    _root.visits = 0;
    
    return self;
}

- (void)addSample:(FPCpuSample *)sample {
    /*
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
     */     
}

- (void)computeTimes {
    /*
     def compute
     total = @root.visits.to_f
     
     f = Proc.new do |child| 
     child.time = child.visits / total
     child.children.each &f
     end
     
     @root.time = 1
     @root.children.each &f
     end
     */     
}

- (NSString *)describe {
    return [_root indentedDescription:0];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_root forKey:@"root"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [super init];
    
    _root = [decoder decodeObjectForKey:@"root"];
    
    return self;
}


@end
