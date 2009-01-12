//
//  FPAgentController.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/6/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPAgentController.h"
#import "NonZeroLengthArrayValueTransformer.h"


@implementation FPAgentController

@synthesize table = _table;
@synthesize sessions = _sessions;
@synthesize agents = _agents;
@synthesize agentsController = _agentsController;

- (IBAction)connectToAgent:(id)sender {
    NSInteger row = [_table selectedRow];
    
    if( row >= 0 ) {
        FPAgent *agent; // TODO look up agent
        
        NSLog(@"Will create session for %@", agent);
        
        FPProfilingSession *session = [[FPProfilingSession alloc] initWithAgent: agent];
        
        [_sessions addDocument: session];
        [session makeWindowControllers];
        [session showWindows];
    } 
}

+ (void)initialize {
    [NSValueTransformer setValueTransformer:[[NonZeroLengthArrayValueTransformer alloc] init] 
                                    forName:@"NonZeroLengthArray"];
}

- (void)awakeFromNib {
    //# FIXME remove the below once done testing
    //# url = NSURL.fileURLWithPath "~/Desktop/test two.profiler-session-data".stringByExpandingTildeInPath
    //# url = NSURL.fileURLWithPath "~/Desktop/modo2.profiler-session-data".stringByExpandingTildeInPath
    //# sessions.openDocumentWithContentsOfURL url, display: true, error: nil

    FPNewAgentListener *listener = [[FPNewAgentListener alloc] initWithDelegate:self];
    
    _thread = [[FPIoThread alloc] initWithListener:listener];
    [_thread start];
}

- (void)agentConnected:(FPAgent *)agent {
    [_agentsController performSelectorOnMainThread:@selector(addObject:) withObject:agent waitUntilDone:YES];
}


@end
