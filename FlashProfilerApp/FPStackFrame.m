//
//  FPStackFrame.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/9/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "FPStackFrame.h"


@implementation FPStackFrame

@synthesize className = _className;
@synthesize methodName = _methodName;
@synthesize file = _file;
@synthesize line = _line;

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithClassName:methodName:file:line" 
                                 userInfo:nil];
    
    return nil;
}


- (id)initWithClassName:(NSString *)className methodName:(NSString *)methodName {
    return [self initWithClassName:className methodName:methodName file:nil line:0];
}

- (id)initWithClassName:(NSString *)className 
             methodName:(NSString *)methodName 
                   file:(NSString *)file 
                   line:(NSUInteger)line {
    [super init];

    _className = className;
    _methodName = methodName;
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
        [_className isEqual:[other className]] && 
        [_methodName isEqual:[other methodName]] &&
        [_file isEqual:[other file]] &&
        _line == [other line];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger hash = 1;
    
    hash = hash * prime + [_className hash];
    hash = hash * prime + [_methodName hash];
    hash = hash * prime + [_file hash];
    hash = hash * prime + _line;
    
    return hash;
}


- (NSString *)description {
    if( _line ) {
        return [[NSString alloc] initWithFormat:@"%@/%@(%@:%d)", _className, _methodName, _file, _line];
    } else {
        return [[NSString alloc] initWithFormat:@"%@/%@", _className, _methodName];
    }
}

- (id)initWithCoder:(NSCoder *)coder {
    [super init];
    
    // TODO    
    /*
     def initWithCoder(coder)
     @class_name = coder.decodeObjectForKey("class_name")
     @method_name = coder.decodeObjectForKey("method_name")
     @file = coder.decodeObjectForKey("file")
     @line = coder.decodeIntegerForKey("line")
     @line = nil if @line == 0
     
     self
     
     */    
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    //    TODO
    /*
     def encodeWithCoder(coder)
     coder.encodeObject class_name, forKey: "class_name"
     coder.encodeObject method_name, forKey: "method_name"
     coder.encodeObject file, forKey: "file"
     coder.encodeInteger line, forKey: "line" if not line.nil?
     end  
     
     */
}

@end
