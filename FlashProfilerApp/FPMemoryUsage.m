//
//  FPMemoryUsage.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPMemoryUsage.h"


@implementation FPMemoryUsage

@synthesize at = _at;
@synthesize usage = _usage;

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithUsage:at" 
                                 userInfo:nil];
    
    return nil;
}

- (id)initWithUsage:(NSUInteger)usage at:(NSDate *)date {
    [super init];
    
    _usage = usage;
    _at = date;
    
    return self;
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"[MemoryUsage usage=%d, at %@]", _usage, _at];
}

- (id)initWithCoder:(NSCoder *)coder {
    [super init];
    
    _at = [coder decodeObjectForKey:@"date"];
    _usage = [coder decodeIntegerForKey:@"usage"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_at forKey:@"date"];
    [coder encodeInteger:_usage forKey:@"usage"];
}

@end
