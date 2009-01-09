//
//  FPSampleSet.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/7/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "FPSampleSet.h"


@implementation FPSampleSet

@synthesize callTree;
@synthesize objects;
@synthesize cpu;

- (id)init {
    [super init];
    
    callTree = [[FPCallTree alloc] init];
    objects = [NSMutableArray arrayWithCapacity:32];
    cpu = [NSMutableArray arrayWithCapacity:32];
    objectsById = [NSMutableDictionary dictionaryWithCapacity:32];
    
    return self;
}

- (void)add:(FPSample *)sample {
// TODO     
/*
 case sample
 when CpuSample
 @cpu << sample
 @call_tree << sample
 when NewObjectSample
 @objects << sample
 @objects_by_id[sample.id] = sample
 when DeleteObjectSample
 @objects << sample
 new_object = @objects_by_id[sample.id]
 
 if not new_object.nil?
 new_object.deleted = sample
 sample.created = new_object
 end
 end
 */
}

- (id)initWithCoder:(NSCoder *)coder {
    [super init];

// TODO    
//    @cpu = coder.decodeObjectForKey("cpu")
//    @objects = coder.decodeObjectForKey("objects")
//    @objects_by_id = coder.decodeObjectForKey("objects_by_id")
//    @call_tree = coder.decodeObjectForKey("call_tree")
    
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
//    TODO
//    coder.encodeObject cpu, forKey: "cpu"
//    coder.encodeObject objects, forKey: "objects"
//    coder.encodeObject call_tree, forKey: "call_tree"
//    coder.encodeObject @objects_by_id, forKey: "objects_by_id"    
}

@end
