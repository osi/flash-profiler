//
//  FPProfilingSession.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPAgent.h"
#import "FPSampleSet.h"
#import "FPIoThread.h"
#import "FPMemoryUsage.h"


@interface FPProfilingSession : NSDocument {
    FPAgent *_agent;
    FPIoThread *_ioThread;
    NSMutableArray *_memoryUsage;
    NSMutableArray *_sampleSets;
    FPSampleSet *_viewingSampleSet;
}

@property(readonly) FPAgent *agent;
@property(readonly) FPIoThread *ioThread;
@property(readonly) NSArray *memoryUsage;
@property(readonly) NSArray *sampleSets;

- (id)initWithAgent:(FPAgent *)agent ioThread:(FPIoThread *)ioThread;

- (void)addSampleSet:(FPSampleSet *)set;

- (void)addMemoryUsage:(FPMemoryUsage *)usage;

@end
