//
//  FPNewAgentListener.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"
#import "FPAgent.h"

@protocol FPNewAgentListenerDelegate

- (void)agentConnected:(FPAgent *)agent;

@end


@interface FPNewAgentListener : NSObject {
    id _delegate;
    AsyncSocket *_socket;
    NSString *_host;
    NSUInteger _port;
}

@property(retain) NSString *host;
@property NSUInteger port;

- (id)initWithDelegate:(id)delegate;
- (void)start;

@end
