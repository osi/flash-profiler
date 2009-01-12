//
//  FPSample.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "FPSample.h"


@implementation FPSample

@synthesize at = _at;

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithTime" 
                                 userInfo:nil];
    
    return nil;
}

- (id)initWithTime:(NSDate *)takenAt rawValue:(NSString *)value {
    [super init];
    
    _at = takenAt;
    _rawTime = value;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_at forKey:@"at"];
    [coder encodeObject:_rawTime forKey:@"rawTime"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [super init];
    
    _at = [decoder decodeObjectForKey:@"at"];
    _rawTime = [decoder decodeObjectForKey:@"rawTime"];
    
    return self;
}

@end