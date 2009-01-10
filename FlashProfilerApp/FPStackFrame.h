//
//  FPStackFrame.h
//  FlashProfilerApp
//
//  Created by peter royal on 1/9/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FPStackFrame : NSObject <NSCoding> {
    NSString *_className;
    NSString *_methodName;
    NSString *_file;
    NSUInteger _line;
}

@property(readonly) NSString *className;
@property(readonly) NSString *methodName;
@property(readonly) NSString *file;
@property(readonly) NSUInteger line;

- (id)initWithClassName:(NSString *)className methodName:(NSString *)methodName;

- (id)initWithClassName:(NSString *)className methodName:(NSString *)methodName file:(NSString *)file line:(NSUInteger)line;

@end
