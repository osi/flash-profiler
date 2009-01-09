//
//  FPProfilingSession.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPProfilingSession : NSDocument {
    FPAgent *agent;
    NSMutableArray *memoryUsage;
    NSMutableArray *sampleSets;
    FPSampleSet *viewingSampleSet;
}

@property FPAgent agent;
@property NSMutableArray memoryUsage;
@property NSMutableArray sampleSets;

- (id)initWithAgent:(FPAgent *)theAgent
- (void)addSampleSet:(FPSampleSet *)set;

@end
