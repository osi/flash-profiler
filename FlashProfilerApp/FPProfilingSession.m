//
//  FPProfilingSession.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "FPProfilingSession.h"
#import "FPAgent.h"
#import "FPSampleSet.h"


@implementation FPProfilingSession

@synthesize agent = _agent;
@synthesize memoryUsage = _memoryUsage;
@synthesize sampleSets = _sampleSets;

- (id)init {
    return [self initWithAgent: nil];
}

- (id)initWithAgent:(FPAgent *)agent {
    [super init];

    _agent = agent;
    _memoryUsage = [NSMutableArray arrayWithCapacity:128];
    _sampleSets = [NSMutableArray arrayWithCapacity:8];
    _viewingSampleSet = nil;
    
    [agent setDelegate:self];
    
    return self;
}

- (void)addSampleSet:(FPSampleSet *)set {
    [_sampleSets addObject:set];
    [self updateChangeCount:NSChangeDone];
}

// NSDoument overrides

- (void)makeWindowControllers {
//    addWindowController ProfilingSessionController.alloc.initWithWindowNibName("ProfilingSession")
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
//    TODO
    //    NSKeyedArchiver.archivedDataWithRootObject [memory_usage, sample_sets]

    
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
//    TODO
//    stored = NSKeyedUnarchiver.unarchiveObjectWithData data
//    @memory_usage = stored[0]
//    @sample_sets = stored[1]
//# TODO outError is a Pointer instance.
//# error = NSError.errorWithDomain NSOSStatusErrorDomain, code: -4, userInfo: nil
    
    return YES;
}

@end
