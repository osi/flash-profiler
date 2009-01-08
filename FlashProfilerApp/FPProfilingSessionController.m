//
//  ProfilingSessionController.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "FPProfilingSessionController.h"


@implementation FPProfilingSessionController

@synthesize collectButton;
@synthesize cpuView;

/*
 def awakeFromNib
 @viewing_sample_set = nil
 @agent = document.agent
 
 if not @agent.nil?
 @timer = NSTimer.scheduledTimerWithTimeInterval 1, 
 target: self, 
 selector: :get_memory_usage, 
 userInfo: nil, 
 repeats: true
 end
 
 formatter = NSNumberFormatter.alloc.init
 formatter.numberStyle = NSNumberFormatterPercentStyle
 
 @cpu_view.tableColumnWithIdentifier("time").dataCell.formatter = formatter
 
 if not document.sample_sets.empty?
 self.viewing_sample_set = document.sample_sets[0]
 end
 
 memory_graph.reloadData
 end
 
 def get_memory_usage
 begin
 usage = @agent.memory_usage
 rescue Exception => e
 NSLog "Memory retrieval failed. #{e}"
 
 @timer.invalidate
 
 return
 end
 
 if document.nil?
 # FIXME putting this in a 'dealloc' seems to kill things
 @timer.invalidate
 return
 end
 
 document.memory_usage.push usage
 document.updateChangeCount NSChangeDone
 
 memory_graph.reloadData
 
 frame = memory_graph.frame
 memory_graph_scroll.documentView.scrollPoint NSPoint.new(frame.size.width + frame.origin.x, frame.origin.y)
 
 NSLog "#{usage}"
 end
 
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
 
 public
 
 # GraphView delegate
 
 def valuesForGraphView(view)
 document.memory_usage
 end 
*/ 

@end
