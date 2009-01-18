//
//  FPAgent.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/8/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"
#import "FPMemoryUsage.h"

@interface FPAgent : NSObject {
    AsyncSocket *_socket;
    id _delegate;
    NSDate *_remoteTime;
}

- (id)initWithSocket:(AsyncSocket *)socket;

- (BOOL)isConnected;

- (void)setDelegate:(id)delegate;

- (void)memoryUsage;
//- (FPSampleSet *)samples;
//- (IBAction)startSampling;
//- (IBAction)pauseSampling;
//- (IBAction)stopSampling;
//- (BOOL)isSampling;

@end

@protocol FPAgentDelegate

- (void)agentDisconnected:(FPAgent *)agent withReason:(NSError *)reason;

@optional

- (void)agentConnected:(FPAgent *)agent;

- (void)memoryUsage:(FPMemoryUsage *)usage forAgent:(FPAgent *)agent;

@end