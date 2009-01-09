//
//  FPSampleSet.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPSampleSet : NSObject <NSCoding> {
    FPCallTree *callTree;
    NSMutableArray *objects;
    NSMutableArray *cpu;
    NSMutableDictionary *objectsById;
}

@property(readonly) FPCallTree *callTree;
@property(readonly) NSMutableArray *objects;
@property(readonly) NSMutableArray *cpu;

- (void)add:(FPSample *)sample;

@end
