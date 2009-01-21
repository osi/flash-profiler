//
//  FPCpuSample.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPCpuSample.h"


@implementation FPCpuSample

@synthesize stack = _stack;

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithStack" 
                                 userInfo:nil];
    
    return nil;
}

- (id)initWithStack:(NSArray *)stack {
    [super init];
    
    _stack = stack;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_stack forKey:@"stack"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [super init];
    
    _stack = [decoder decodeObjectForKey:@"stack"];
    
    return self;
}


@end
