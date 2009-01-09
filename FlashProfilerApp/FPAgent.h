//
//  FPAgent.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/8/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPAgent : NSObject {
    AsyncSocket *socket;
}

- (id)initWithSocket:(AsyncSocket *)socket;

- (BOOL)isConnected;
//- (FPMemoryUsage *)memoryUsage;
//- (FPSampleSet *)samples;
//- (IBAction)startSampling;
//- (IBAction)pauseSampling;
//- (IBAction)stopSampling;
//- (BOOL)isSampling;

@end
