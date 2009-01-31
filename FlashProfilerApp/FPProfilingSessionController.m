//
//  ProfilingSessionController.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPProfilingSessionController.h"
#import "FPProfilingSession.h"

@interface FPProfilingSessionController (Private)

- (void)startTimer;
- (void)setupTimer;
- (void)stopTimer;

@end


@implementation FPProfilingSessionController

@synthesize collectButton = _collectButton;
@synthesize cpuView = _cpuView;
@synthesize memoryGraph = _memoryGraph;

- (void)awakeFromNib {
    _agent = [[self document] agent];
    _ioThread = [[self document] ioThread];
    
    if( _agent != nil ) {
        [_agent setDelegate:self];
        [self startTimer];
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

- (void)startTimer {
    [self performSelector:@selector(setupTimer) onThread:_ioThread withObject:nil waitUntilDone:YES];
    NSLog(@"Started memory collection timer");
}

- (void)setupTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 
                                              target:_agent 
                                            selector:@selector(memoryUsage) 
                                            userInfo:nil 
                                             repeats:YES];
}

- (void)stopTimer {
    [_timer performSelector:@selector(invalidate) onThread:_ioThread withObject:nil waitUntilDone:YES];
    _timer = nil;
    NSLog(@"Stopped memory collection timer");
}

- (void)agentDisconnected:(FPAgent *)agent withReason:(NSError *)reason {
    NSLog(@"Invaliding timer since agent disconnected");
    [self stopTimer];
}

- (void)memoryUsage:(FPMemoryUsage *)usage forAgent:(FPAgent *)agent {
    NSLog(@"%@", usage);
    
    FPProfilingSession *session = [self document];
    
    [[session memoryUsage] addObject:usage];
    [session updateChangeCount:NSChangeDone];
    
    [_memoryGraph reloadData];
    
    // TODO only scroll if we are already scrolled all the way to the right
    NSRect frame = [_memoryGraph frame];
    [_memoryGraph scrollPoint:NSMakePoint(frame.size.width + frame.origin.x, frame.origin.y)];
}

- (void)startedSampling:(FPAgent *)agent {
    NSLog(@"Started Sampling");
}
- (void)pausedSampling:(FPAgent *)agent {
    NSLog(@"Paused Sampling");
    
    [self stopTimer];
    [_agent performSelector:@selector(samples) onThread:_ioThread withObject:nil waitUntilDone:NO];
    //[_agent stopSampling];
    //document.add_sample_set samples
}
- (void)stoppedSampling:(FPAgent *)agent {
    NSLog(@"Stopped Sampling");
}

- (NSArray *)valuesForGraphView:(FPGraphView *)graphView {
    FPProfilingSession *session = [self document];
    return [[session memoryUsage] copy];
}

- (IBAction)collectButtonAction:(id)sender {
    // TODO should make the window "busy" while waiting for the command to finish
    if( [_agent isSampling] ) {
        [_agent performSelector:@selector(pauseSampling) onThread:_ioThread withObject:nil waitUntilDone:NO];
    } else {
        [_agent performSelector:@selector(startSampling) onThread:_ioThread withObject:nil waitUntilDone:NO];
    }
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)item {
    if( item == _collectButton ) {
        if( _agent == nil || ![_agent isConnected]) {
            [item setLabel:@"Not Connected"];
            return NO;
        } else if( [_agent isSampling] ) {
            [item setLabel:@"Stop"];
        } else {
            [item setLabel:@"Collect"];
        }
    }
    
    return YES;
}

/*
 # FIXME temporary code since set-on-load
 def viewing_sample_set=(set)
 @viewing_sample_set = set
 @cpu_view.reloadData
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
