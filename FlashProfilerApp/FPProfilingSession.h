//
//  FPProfilingSession.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPAgent.h"
#import "FPSampleSet.h"


@interface FPProfilingSession : NSDocument <FPAgentDelegate> {
    FPAgent *_agent;
    NSMutableArray *_memoryUsage;
    NSMutableArray *_sampleSets;
    FPSampleSet *_viewingSampleSet;
}

@property FPAgent *agent;
@property(retain) NSMutableArray *memoryUsage;
@property(retain) NSMutableArray *sampleSets;

- (id)initWithAgent:(FPAgent *)agent;

- (void)addSampleSet:(FPSampleSet *)set;

@end
