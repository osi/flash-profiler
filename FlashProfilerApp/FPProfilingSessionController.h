//
//  ProfilingSessionController.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPAgent.h"
#import "FPIoThread.h"
#import "FPGraphView.h"


@interface FPProfilingSessionController : NSWindowController <FPAgentDelegate, FPGraphViewDataSource> {
    NSToolbarItem *_collectButton;
    NSOutlineView *_cpuView;
    FPAgent *_agent;
    FPIoThread *_ioThread;
    NSTimer *_timer;
    FPGraphView *_memoryGraph;
    NSScrollView *_memoryGraphScroller;
}

@property IBOutlet NSToolbarItem *collectButton;
@property IBOutlet NSOutlineView *cpuView;
@property IBOutlet FPGraphView *memoryGraph;
@property IBOutlet NSScrollView *memoryGraphScroller;

@end
