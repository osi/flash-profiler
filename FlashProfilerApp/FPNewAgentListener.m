//
//  FPNewAgentListener.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "FPNewAgentListener.h"


@implementation FPNewAgentListener

@synthesize host = _host;
@synthesize port = _port;

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithDelegate" 
                                 userInfo:nil];
    
    return nil;
}

- (id)initWithAgentDelegate:(id)delegate {
    [super init];
    
    _delegate = delegate;
    _host = @"localhost";
    _port = 42624;
    _socket = [[AsyncSocket alloc] initWithDelegate:self];
    
    return self;
}

- (void)start {
    NSError *error = nil;
    
    if([_socket acceptOnAddress:_host port:_port error:&error]) {
        NSLog(@"Started server at %@:%i", _host, _port);
    } else {
        NSLog(@"Unable to start server %@", error);
    }
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket {
    NSLog(@"Will make agent for %@", newSocket);
    
    FPAgent *agent = [[FPAgent alloc] initWithSocket:newSocket];
    [agent setDelegate:_delegate];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    NSLog(@"Listener closing due to %@", err);
}

@end
