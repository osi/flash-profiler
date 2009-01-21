//
//  FPCallTreeNode.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/9/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPCallTreeNode.h"


@implementation FPCallTreeNode

@synthesize frame = _frame;
@synthesize children = _children;
@synthesize visits = _visits;
@synthesize time = _time;

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithFrame" 
                                 userInfo:nil];
    
    return nil;
}

- (id)initWithStackFrame:(FPStackFrame *)frame {
    [super init];
    
    _frame = frame;
    _children = [NSMutableArray arrayWithCapacity:16];
    _visits = 1;
    
    return self;
}

- (BOOL)hasChild:(FPStackFrame *)frame {
    return [self childNodeForFrame:frame] ? YES : NO;
}

- (FPCallTreeNode *)childNodeForFrame:(FPStackFrame *)frame {
    for( FPCallTreeNode *child in _children ) {
        if( [frame isEqual:[child frame]] ) {
            return child;
        }
    }
    
    return nil;
}

- (void)addChildNode:(FPCallTreeNode *)node {
    [_children addObject:node];
}

- (NSString *)indentedDescription:(NSUInteger)level {
//    "  " * level << 
//    (time * 100).round.to_s << 
//    " " <<
//    frame.to_s << 
//    children.map { |child| "\n" << child.nested_to_s(level+1) }.join
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
//    coder.encodeObject frame, forKey: "frame"
//    coder.encodeObject children, forKey: "children"
//    coder.encodeInteger visits, forKey: "visits"
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    [super init];

//    @frame = coder.decodeObjectForKey("frame")
//    @children = coder.decodeObjectForKey("children")
//    @visits = coder.decodeIntegerForKey("visits")
    
    
    return self;
}


@end
