//
//  FPMemoryUsage.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPMemoryUsage : NSObject <NSCoding> {
    NSDate *at;
    int usage;
}

@property(readonly) NSDate *at;
@property(readonly) int usage;

- (id)initWithUsage:(int)theUsage at:(NSDate *)theDate;

@end
