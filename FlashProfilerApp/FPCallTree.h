//
//  FPCallTree.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/8/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPCallTreeNode.h"
#import "FPCpuSample.h"

@interface FPCallTree : NSObject <NSCoding> {
    FPCallTreeNode *_root;
}

@property(readonly) FPCallTreeNode *root;

- (void)addSample:(FPCpuSample *)sample;
- (void)computeTimes;

@end
