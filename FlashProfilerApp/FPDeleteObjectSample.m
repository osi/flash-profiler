//
//  FPDeleteObjectSample.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/31/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPDeleteObjectSample.h"


@implementation FPDeleteObjectSample

@synthesize identifier = _identifier;
@synthesize size = _size;

- (id)initWithIdentifier:(NSUInteger)identifier 
                    size:(NSUInteger)size 
              atLocation:(NSArray *)stack 
                      at:(NSDate *)takenAt {
    [super initWithStack:stack at:takenAt];
    
    _identifier = identifier;
    _size = size;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:[NSNumber numberWithUnsignedInteger:_identifier] forKey:@"id"];
    [coder encodeObject:[NSNumber numberWithUnsignedInteger:_size] forKey:@"size"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [super initWithCoder:decoder];
    
    _identifier = [[decoder decodeObjectForKey:@"id"] unsignedIntegerValue];
    _size = [[decoder decodeObjectForKey:@"size"] unsignedIntegerValue];
    
    return self;
}

@end
