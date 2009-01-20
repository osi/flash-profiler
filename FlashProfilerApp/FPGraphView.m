//
//  FPGraphView.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/18/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "FPGraphView.h"
#import "FPMemoryUsage.h"

static int SECOND_TICK = 10;

@interface FPGraphView (Private)

- (void)redraw;
- (void)drawGrid;
- (void)drawPath;

@end


@implementation FPGraphView

@synthesize dataSource = _dataSource;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.

        _valuePath = [NSBezierPath bezierPath];
        _valuePath.lineWidth = 2.0;
        _valuePath.lineJoinStyle = NSRoundLineJoinStyle;
        
        const CGFloat pattern[2] = {2, 10};
        
        _gridPath = [NSBezierPath bezierPath];
        _gridPath.lineWidth = 0.5;
        [_gridPath setLineDash:pattern count:2 phase:0];
        
        _needsRedraw = NO;
        _pathHeight = 0;
        _values = [NSArray array];
        
        NSSortDescriptor *memoryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"usage" ascending:YES];
        _valuesSortDescriptors = [NSArray arrayWithObject:memoryDescriptor];
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:rect];
    
    if( _needsRedraw || ([self bounds].size.height != _pathHeight) ) {
        [self redraw];
    }
    
    [[NSColor grayColor] set];
    [_gridPath stroke];
    
    [[NSColor greenColor] set];
    [_valuePath stroke];
}

- (void)reloadData {
    _values = [_dataSource valuesForGraphView:self];
    
    CGFloat width = [_values count] * SECOND_TICK;
    
    if( width > [self frame].size.width ) {
        [self setFrameSize:NSMakeSize(width, [self frame].size.height)];
    }
    
    _needsRedraw = YES;
    self.needsDisplay = YES;
}

- (void)redraw {
    _pathHeight = [self bounds].size.height;
    _needsRedraw = NO;
    
    [self drawGrid];
    [self drawPath];
}

- (void)drawGrid {
    [_gridPath removeAllPoints];
    
    NSRect bounds = [self bounds];
    CGFloat targetY = bounds.origin.y + bounds.size.height;
    int times = floor(bounds.size.width / SECOND_TICK);
    
    for( int i = 0; i < times; i++) {
        CGFloat x = ((i + 1) * SECOND_TICK) + bounds.origin.x;
        [_gridPath moveToPoint:NSMakePoint(x, 0)];
        [_gridPath lineToPoint:NSMakePoint(x, targetY)];
    }
    
}

- (void)drawPath {
    [_valuePath removeAllPoints];
    
    if( [_values count] == 0 ) {
        return;
    }
    
    NSArray *sorted = [_values sortedArrayUsingDescriptors:_valuesSortDescriptors];
    NSUInteger min = [[sorted objectAtIndex:0] usage];
    NSUInteger max = [[sorted lastObject] usage];
    
    CGFloat yOffset = [self bounds].origin.y;
    CGFloat ratio = (_pathHeight - 5) / (max - min);
    CGFloat currentX = [self bounds].origin.x;
    NSUInteger index = 0;
    
    for (FPMemoryUsage *usage in _values) {
        CGFloat y = (usage.usage - min) * ratio + yOffset;

        if( 0 == index++ ) {
            [_valuePath moveToPoint:NSMakePoint(currentX, y)];
        } else {
            // TODO align on actual time boundary as well
            [_valuePath lineToPoint:NSMakePoint(currentX += SECOND_TICK, y)];
        }
    }
}

@end
