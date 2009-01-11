//
//  FPAgentController.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/6/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPAgent.h"
#import "FPProfilingSession.h"


@interface FPAgentController : NSObject {
    NSDocumentController *_sessions;
    NSTableView *_table;
    NSMutableArray *_agents;
}

@property IBOutlet NSDocumentController *sessions;
@property IBOutlet NSTableView *table;
@property(readonly) NSMutableArray *agents;

- (IBAction)connectToAgent:(id)sender;

@end
