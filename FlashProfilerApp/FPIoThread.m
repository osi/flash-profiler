//
//  FPIoThread.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPIoThread.h"


@implementation FPIoThread

@synthesize run = _run;

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithListener" 
                                 userInfo:nil];
    
    return nil;
}


- (id)initWithListener:(FPNewAgentListener *)listener {
    [super init];

    _listener = listener;
    _run = YES;
    
    return self;
}

- (void)main {
    NSLog(@"Starting io thread");

    [_listener start];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

    while (_run && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
        // nothing!
    }
    
    NSLog(@"io thread exiting");
}

@end
