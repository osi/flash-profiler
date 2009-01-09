//
//  FPAgentController.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/6/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPAgentController : NSObject {
    NSDocumentController *sessions;
    NSTableView *table;
}

@property IBOutlet NSDocumentController *sessions;
@property IBOutlet NSTableView *table;

- (IBAction)connectToAgent:(id)sender;

@end
