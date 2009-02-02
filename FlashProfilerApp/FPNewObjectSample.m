//
//  FPNewObjectSample.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/31/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPNewObjectSample.h"


@implementation FPNewObjectSample

@synthesize identifier = _identifier;
@synthesize type = _type;
@synthesize deleted = _deleted;

- (id)initWithIdentifier:(NSUInteger)identifier ofType:(NSString *)type atLocation:(NSArray *)stack at:(NSDate *)takenAt {
    [super initWithStack:stack at:takenAt];
    
    _identifier = identifier;
    _type = _type;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:[NSNumber numberWithUnsignedInteger:_identifier] forKey:@"id"];
    [coder encodeObject:_type forKey:@"type"];
    [coder encodeObject:_deleted forKey:@"deleted"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [super initWithCoder:decoder];
    
    _identifier = [[decoder decodeObjectForKey:@"id"] unsignedIntegerValue];
    _type = [decoder decodeObjectForKey:@"type"];
    _deleted = [decoder decodeObjectForKey:@"deleted"];
    
    return self;
}

@end
