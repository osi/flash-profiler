//
//  FPGraphView.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/18/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPGraphView : NSView {
    id _dataSource;
    NSBezierPath *_valuePath;
    NSBezierPath *_gridPath;
    BOOL _needsRedraw;
    CGFloat _pathHeight;
    NSArray *_values;
    NSArray *_valuesSortDescriptors;
}

@property IBOutlet id dataSource;

- (void)reloadData;

@end


@protocol FPGraphViewDataSource

- (NSArray *)valuesForGraphView:(FPGraphView *)graphView;

@end
