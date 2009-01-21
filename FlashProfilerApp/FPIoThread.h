//
//  FPIoThread.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/10/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FPNewAgentListener.h"

@interface FPIoThread : NSThread {
    BOOL _run;
    FPNewAgentListener *_listener;
}

@property BOOL run;

- (id)initWithListener:(FPNewAgentListener *)listener;

@end
