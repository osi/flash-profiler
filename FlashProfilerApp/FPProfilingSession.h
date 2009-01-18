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
#import "FPIoThread.h"


@interface FPProfilingSession : NSDocument {
    FPAgent *_agent;
    FPIoThread *_ioThread;
    NSMutableArray *_memoryUsage;
    NSMutableArray *_sampleSets;
    FPSampleSet *_viewingSampleSet;
}

@property(readonly) FPAgent *agent;
@property(readonly) FPIoThread *ioThread;
@property(retain) NSMutableArray *memoryUsage;
@property(retain) NSMutableArray *sampleSets;

- (id)initWithAgent:(FPAgent *)agent ioThread:(FPIoThread *)ioThread;

- (void)addSampleSet:(FPSampleSet *)set;

@end
