//
//  FPSample.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPSample : NSObject <NSCoding> {
    NSDate *_at;
    NSArray *_stack;
}

@property(readonly) NSDate *at;
@property(readonly) NSArray *stack;

- (id)initWithStack:(NSArray *)stack at:(NSDate *)takenAt;

@end
