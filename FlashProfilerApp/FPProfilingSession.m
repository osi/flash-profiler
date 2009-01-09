//
//  FPProfilingSession.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "FPProfilingSession.h"


@implementation FPProfilingSession

@synthesize agent;
@synthesize memoryUsage;
@synthesize sampleSets;

- (id)init {
    return [self initWithAgent: nil];
}

- (id)initWithAgent:(FPAgent *)theAgent {
    [super init];

    agent = theAgent;
    memoryUsage = [NSMutableArray arrayWithCapacity:128];
    sampleSets = [NSMutableArray arrayWithCapacity:8];
    viewingSampleSet = nil;
    
    return self;
}

- (void)addSampleSet:(FPSampleSet *)set {
    [sampleSets addObject:set];
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
