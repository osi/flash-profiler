//
//  FPCpuSample.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPSample.h"

@interface FPCpuSample : FPSample <NSCoding> {
    NSArray *_stack;
}

@property(readonly) NSArray *stack;

- (id)initWithStack:(NSArray *)stack at:(NSDate *)takenAt;

@end
