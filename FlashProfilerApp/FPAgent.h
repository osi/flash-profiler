//
//  FPAgent.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/8/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"
#import "FPMemoryUsage.h"

typedef enum samplingState { Stopped, Paused, Started } SamplingState;

@interface FPAgent : NSObject {
    AsyncSocket *_socket;
    id _delegate;
    NSDate *_remoteTime;
    SamplingState _samplingState;
}

- (id)initWithSocket:(AsyncSocket *)socket;

- (BOOL)isConnected;

- (void)setDelegate:(id)delegate;

- (void)memoryUsage;

- (BOOL)isSampling;
//- (FPSampleSet *)samples;
//- (IBAction)startSampling;
//- (IBAction)pauseSampling;
//- (IBAction)stopSampling;

@end

@protocol FPAgentDelegate

- (void)agentDisconnected:(FPAgent *)agent withReason:(NSError *)reason;

@optional

- (void)agentConnected:(FPAgent *)agent;

- (void)memoryUsage:(FPMemoryUsage *)usage forAgent:(FPAgent *)agent;

@end