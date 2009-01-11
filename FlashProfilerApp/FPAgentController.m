//
//  FPAgentController.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/6/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPAgentController.h"


@implementation FPAgentController

@synthesize table = _table;
@synthesize sessions = _sessions;
@synthesize agents = _agents;

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

//
//def awakeFromNib
//# FIXME remove the below once done testing
//# url = NSURL.fileURLWithPath "~/Desktop/test two.profiler-session-data".stringByExpandingTildeInPath
//# url = NSURL.fileURLWithPath "~/Desktop/modo2.profiler-session-data".stringByExpandingTildeInPath
//# sessions.openDocumentWithContentsOfURL url, display: true, error: nil
//
//# FIXME don't be evil and grab focus for testing
//# NSApplication.sharedApplication.activateIgnoringOtherApps true
//
//listener = Listener.new(tracker)
//
//io_thread = IoThread.alloc.initWithListener(listener)
//io_thread.start
//
//# @thread = Thread.new do
//#   run = true
//# 
//#   NSLog "Starting io thread"
//# 
//#   listener.start
//# 
//#   NSLog "Started listener"
//# 
//#   run_loop = NSRunLoop.currentRunLoop
//# 
//#   STDERR.puts "#{run_loop}"
//# 
//#   begin
//#     while run and run_loop.runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture)
//#       # NSLog "run..."
//#       # do nothing!
//#     end
//#   rescue Exception => e
//#     NSLog "Failure in run loop #{e}"
//#   end
//#   
//# 
//#   NSLog "io thread exiting.."      
//# end
//end

@end
