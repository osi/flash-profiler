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
    NSString *_rawTime;
}

@property(readonly) NSDate *at;

- (id)initWithTime:(NSDate *)takenAt rawValue:(NSString *)value;

@end
