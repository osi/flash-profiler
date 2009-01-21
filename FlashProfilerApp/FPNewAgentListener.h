//
//  FPNewAgentListener.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"
#import "FPAgent.h"

@interface FPNewAgentListener : NSObject {
    id _delegate;
    AsyncSocket *_socket;
    NSString *_host;
    NSUInteger _port;
}

@property(retain) NSString *host;
@property NSUInteger port;

- (id)initWithAgentDelegate:(id)delegate;
- (void)start;

@end
