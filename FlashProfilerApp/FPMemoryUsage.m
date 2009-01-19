//
//  FPMemoryUsage.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "FPMemoryUsage.h"


@implementation FPMemoryUsage

@synthesize at;
@synthesize usage;

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithUsage:at" 
                                 userInfo:nil];
    
    return nil;
}

- (id)initWithUsage:(NSUInteger)theUsage at:(NSDate *)theDate {
    [super init];
    
    usage = theUsage;
    at = theDate;
    
    return self;
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"[MemoryUsage usage=%d, at %@]", usage, at];
}

- (id)initWithCoder:(NSCoder *)coder {
    [super init];
    
    // TODO    
//    @at = Time.at coder.decodeInt64ForKey("at_sec"), coder.decodeInt64ForKey("at_usec")
//    @usage = coder.decodeInt64ForKey("usage")
    
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    //    TODO
//    coder.encodeInt64 at.sec, forKey: "at_sec"
//    coder.encodeInt64 at.usec, forKey: "at_usec"
//    coder.encodeInt64 usage, forKey: "usage"
}

@end
