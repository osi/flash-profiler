//
//  FPDeleteObjectSample.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/31/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPSample.h"

@interface FPDeleteObjectSample : FPSample <NSCoding> {
    NSUInteger _identifier;
    NSUInteger _size;
}

@property(readonly) NSUInteger identifier;
@property(readonly) NSUInteger size;

- (id)initWithIdentifier:(NSUInteger)identifier 
                    size:(NSUInteger)size 
              atLocation:(NSArray *)stack 
                      at:(NSDate *)takenAt;

@end
