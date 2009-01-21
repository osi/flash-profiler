//
//  ProfilingSessionController.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPProfilingSessionController.h"
#import "FPProfilingSession.h"

@implementation FPProfilingSessionController

@synthesize collectButton = _collectButton;
@synthesize cpuView = _cpuView;
@synthesize memoryGraph = _memoryGraph;

- (void)awakeFromNib {
    _agent = [[self document] agent];
    _ioThread = [[self document] ioThread];
    
    if( _agent != nil ) {
        [_agent setDelegate:self];
        [self performSelector:@selector(setupTimer) onThread:_ioThread withObject:nil waitUntilDone:NO];
    }
    
/*
 @viewing_sample_set = nil
 
 formatter = NSNumberFormatter.alloc.init
 formatter.numberStyle = NSNumberFormatterPercentStyle
 
 @cpu_view.tableColumnWithIdentifier("time").dataCell.formatter = formatter
 
 if not document.sample_sets.empty?
 self.viewing_sample_set = document.sample_sets[0]
 end
*/ 
    [_memoryGraph reloadData];
}

- (void)setupTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 
                                              target:_agent 
                                            selector:@selector(memoryUsage) 
                                            userInfo:nil 
                                             repeats:YES];
}

- (void)agentDisconnected:(FPAgent *)agent withReason:(NSError *)reason {
    NSLog(@"Invaliding timer since agent disconnected");
    [_timer invalidate];
}

- (void)memoryUsage:(FPMemoryUsage *)usage forAgent:(FPAgent *)agent {
    NSLog(@"%@", usage);
    
    FPProfilingSession *session = [self document];
    
    [[session memoryUsage] addObject:usage];
    [session updateChangeCount:NSChangeDone];
    
    [_memoryGraph reloadData];
    
    NSRect frame = [_memoryGraph frame];
    [_memoryGraph scrollPoint:NSMakePoint(frame.size.width + frame.origin.x, frame.origin.y)];
}

- (NSArray *)valuesForGraphView:(FPGraphView *)graphView {
    FPProfilingSession *session = [self document];
    return [[session memoryUsage] copy];
}

/*
 def collect_button_action(sender)
 if @agent.sampling?
 @agent.pause_sampling
 
 samples = @agent.samples
 
 @agent.stop_sampling
 
 document.add_sample_set samples
 else
 @agent.start_sampling
 end
 end
 
 # FIXME temporary code since set-on-load
 def viewing_sample_set=(set)
 @viewing_sample_set = set
 @cpu_view.reloadData
 end
 
 # NSToolbar Delegate
 
 def validateToolbarItem(item)
 if item == @collect_button
 if @agent.nil? or @agent.closed?
 @collect_button.label = "Not Connected" 
 
 return false
 elsif @agent.sampling?
 @collect_button.label = "Stop"
 else
 @collect_button.label = "Collect"
 end
 end
 true
 end
 
 # NSOutlineView delegates
 
 def outlineView(view, numberOfChildrenOfItem:item)
 if @viewing_sample_set.nil?
 0
 else
 current_or_root(item).children.length
 end
 end
 
 def outlineView(view, isItemExpandable:item)
 current_or_root(item).children.length > 0
 end
 
 def outlineView(view, child:child, ofItem:item)
 current_or_root(item).children[child]
 end
 
 def outlineView(view, objectValueForTableColumn:column, byItem:item)
 case column.identifier
 when "location"
 "#{item.frame.class_name}/#{item.frame.method_name}"
 when "time"
 item.time
 end
 end
 
 private
 
 def current_or_root(item)
 item.nil? ? @viewing_sample_set.call_tree.root : item
 end  
 
*/ 

@end
