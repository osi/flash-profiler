//
//  FPSample.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPSample.h"


@implementation FPSample

@synthesize stack = _stack;
@synthesize at = _at;

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithStack:at" 
                                 userInfo:nil];
    
    return nil;
}

- (id)initWithStack:(NSArray *)stack at:(NSDate *)takenAt {
    [super init];
    
    _at = takenAt;
    _stack = stack;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_at forKey:@"at"];
    [coder encodeObject:_stack forKey:@"stack"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [super init];
    
    _at = [decoder decodeObjectForKey:@"at"];
    _stack = [decoder decodeObjectForKey:@"stack"];
    
    return self;
}

@end
