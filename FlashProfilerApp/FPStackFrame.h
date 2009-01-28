//
//  FPStackFrame.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/9/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPStackFrame : NSObject <NSCoding> {
    NSString *_functionName;
    NSString *_file;
    NSUInteger _line;
}

@property(readonly) NSString *functionName;
@property(readonly) NSString *file;
@property(readonly) NSUInteger line;

- (id)initWithFunctionName:(NSString *)name;

- (id)initWithFunctionName:(NSString *)name file:(NSString *)file line:(NSUInteger)line;

@end
