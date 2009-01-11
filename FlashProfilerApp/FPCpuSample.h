//
//  FPCpuSample.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FPCpuSample : NSObject <NSCoding> {
    NSArray *_stack;
}

@property(readonly) NSArray *stack;

- (id)initWithStack:(NSArray *)stack;

@end
