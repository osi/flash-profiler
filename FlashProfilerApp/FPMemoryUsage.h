//
//  FPMemoryUsage.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPMemoryUsage : NSObject <NSCoding> {
    NSDate *_at;
    NSUInteger _usage;
}

@property(readonly) NSDate *at;
@property(readonly) NSUInteger usage;

- (id)initWithUsage:(NSUInteger)usage at:(NSDate *)date;

@end
