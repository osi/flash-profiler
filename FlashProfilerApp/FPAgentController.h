//
//  FPAgentController.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/6/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPAgent.h"
#import "FPProfilingSession.h"
#import "FPNewAgentListener.h"
#import "FPIoThread.h"


@interface FPAgentController : NSObject <FPAgentDelegate> {
    NSDocumentController *_sessions;
    NSTableView *_table;
    NSMutableArray *_agents;
    FPIoThread *_thread;
    NSArrayController *_agentsController;
}

@property IBOutlet NSDocumentController *sessions;
@property IBOutlet NSTableView *table;
@property(readonly) NSMutableArray *agents;
@property IBOutlet NSArrayController *agentsController;

- (IBAction)connectToAgent:(id)sender;

@end
