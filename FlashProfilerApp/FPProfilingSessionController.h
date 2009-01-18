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


@interface FPProfilingSessionController : NSWindowController <FPAgentDelegate> {
//    memory_graph, :memory_graph_scroll, :cpu_view
    NSToolbarItem *_collectButton;
    NSOutlineView *_cpuView;
    FPAgent *_agent;
    FPIoThread *_ioThread;
    NSTimer *_timer;
}

@property(retain) IBOutlet NSToolbarItem *collectButton;
@property IBOutlet NSOutlineView *cpuView;

@end
