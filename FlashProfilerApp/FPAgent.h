//
//  FPAgent.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/8/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"

@interface FPAgent : NSObject {
    AsyncSocket *_socket;
    id _delegate;
}

- (id)initWithSocket:(AsyncSocket *)socket;

- (BOOL)isConnected;

- (void)setDelegate:(id)delegate;
//- (FPMemoryUsage *)memoryUsage;
//- (FPSampleSet *)samples;
//- (IBAction)startSampling;
//- (IBAction)pauseSampling;
//- (IBAction)stopSampling;
//- (BOOL)isSampling;

@end

@protocol FPAgentDelegate

@optional

- (void)agentConnected:(FPAgent *)agent;

@end