//
//  ProfilingSessionController.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPAgent.h"
#import "FPIoThread.h"
#import "FPGraphView.h"


@interface FPProfilingSessionController : NSWindowController <FPAgentDelegate, FPGraphViewDataSource> {
//    :memory_graph_scroll
    NSToolbarItem *_collectButton;
    NSOutlineView *_cpuView;
    FPAgent *_agent;
    FPIoThread *_ioThread;
    NSTimer *_timer;
    FPGraphView *_memoryGraph;
}

@property(retain) IBOutlet NSToolbarItem *collectButton;
@property IBOutlet NSOutlineView *cpuView;
@property IBOutlet FPGraphView *memoryGraph;

@end
