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
#import "FPProfilingSessionController.h"


@implementation FPProfilingSession

@synthesize agent = _agent;
@synthesize ioThread = _ioThread;
@synthesize memoryUsage = _memoryUsage;
@synthesize sampleSets = _sampleSets;

- (id)init {
    return [self initWithAgent:nil ioThread:nil];
}

- (id)initWithAgent:(FPAgent *)agent ioThread:(FPIoThread *)ioThread {
    [super init];

    _agent = agent;
    _ioThread = ioThread;
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
    [self addWindowController:[[FPProfilingSessionController alloc] initWithWindowNibName:@"ProfilingSession"]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    NSMutableData *data = [NSMutableData dataWithCapacity:1024];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:_memoryUsage forKey:@"memory usage"];
    [archiver encodeObject:_sampleSets forKey:@"sample sets"];
    [archiver finishEncoding];
    
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    _memoryUsage = [unarchiver decodeObjectForKey:@"memory usage"];
    _sampleSets = [unarchiver decodeObjectForKey:@"sample sets"];
    
    [unarchiver finishDecoding];
    
    return YES;
}

@end
