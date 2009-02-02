//
//  FPNewObjectSample.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/31/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPSample.h"
#import "FPDeleteObjectSample.h"

@interface FPNewObjectSample : FPSample <NSCoding> {
    NSUInteger _identifier;
    NSString *_type;
    FPDeleteObjectSample *_deleted;
}

@property(readonly) NSUInteger identifier;
@property(readonly) NSString *type;
@property FPDeleteObjectSample *deleted;

- (id)initWithIdentifier:(NSUInteger)identifier 
                  ofType:(NSString *)type 
              atLocation:(NSArray *)stack 
                      at:(NSDate *)takenAt;

@end
