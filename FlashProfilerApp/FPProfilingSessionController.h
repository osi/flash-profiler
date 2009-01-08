//
//  ProfilingSessionController.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPProfilingSessionController : NSWindowController {
//    memory_graph, :memory_graph_scroll, :cpu_view
    NSToolbarItem *collectButton;
    NSOutlineView *cpuView;
}

@property IBOutlet NSToolbarItem collectButton;
@property IBOutlet NSOutlineView cpuView;

@end
