//
//  FPStackFrame.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/9/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPStackFrame.h"


@implementation FPStackFrame

@synthesize functionName = _functionName;
@synthesize file = _file;
@synthesize line = _line;

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithFunctionName:methodName:file:line" 
                                 userInfo:nil];
    
    return nil;
}


- (id)initWithFunctionName:(NSString *)name {
    return [self initWithFunctionName:name file:nil line:0];
}

- (id)initWithFunctionName:(NSString *)name 
                      file:(NSString *)file 
                      line:(NSUInteger)line {
    [super init];

    _functionName = name;
    _file = file;
    _line = line;
    
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    
    return 
        [_functionName isEqual:[other functionName]] && 
        [_file isEqual:[other file]] &&
        _line == [other line];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger hash = 1;
    
    hash = hash * prime + [_functionName hash];
    hash = hash * prime + [_file hash];
    hash = hash * prime + _line;
    
    return hash;
}


- (NSString *)description {
    if( _line ) {
        return [[NSString alloc] initWithFormat:@"%@(%@:%d)", _functionName, _file, _line];
    } else {
        return [[NSString alloc] initWithFormat:@"%@", _functionName];
    }
}

- (id)initWithCoder:(NSCoder *)coder {
    [super init];
    
    _functionName = [coder decodeObjectForKey:@"function"];
    _file = [coder decodeObjectForKey:@"file"];
    
    if( _file != nil ) {
        _line = [coder decodeIntegerForKey:@"line"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_functionName forKey:@"function"];
    [coder encodeObject:_file forKey:@"file"];
    [coder encodeInteger:_line forKey:@"line"];
}

@end
