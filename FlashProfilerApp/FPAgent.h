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
#import "FPSampleSet.h"


typedef enum samplingState { Stopped, Paused, Started } SamplingState;
typedef enum sampleType { NewObject, DeletedObject, CPU } SampleType;

@interface FPAgent : NSObject {
    AsyncSocket *_socket;
    id _delegate;
    NSDate *_remoteTime;
    FPSampleSet *_sampleSet;
    volatile SamplingState _samplingState;
    
    NSMutableDictionary *_readCallbacks;
    NSMutableDictionary *_writeCallbacks;
    long _readId;
    long _writeId;
    
    NSUInteger _expectedSamples;
    SampleType _currentSampleType;
    NSMutableDictionary *_currentSampleData;
    NSUInteger _expectedStackFrames;
}

- (id)initWithSocket:(AsyncSocket *)socket;

- (BOOL)isConnected;

- (void)setDelegate:(id)delegate;

- (void)memoryUsage;

- (BOOL)isSampling;

- (IBAction)startSampling;
- (IBAction)pauseSampling;
- (IBAction)stopSampling;

- (void)samples;

@end

@protocol FPAgentDelegate

- (void)agentDisconnected:(FPAgent *)agent withReason:(NSError *)reason;

@optional

- (void)agentConnected:(FPAgent *)agent;

- (void)memoryUsage:(FPMemoryUsage *)usage forAgent:(FPAgent *)agent;

- (void)startedSampling:(FPAgent *)agent;
- (void)pausedSampling:(FPAgent *)agent;
- (void)stoppedSampling:(FPAgent *)agent;

- (void)samples:(FPSampleSet *)samples forAgent:(FPAgent *)agent;

@end