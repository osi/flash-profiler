//
//  FPAgent.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/8/09.
//  Copyright 2009 Peter Royal. All rights reserved.
//

#import "FPAgent.h"
#import "FPNewObjectSample.h"
#import "FPDeleteObjectSample.h"

short read_short(const unsigned char *bytes, unsigned int offset) {
    return (bytes[offset] << 8) + bytes[offset+1];
}

unsigned int read_unsigned_int(const unsigned char *bytes, unsigned int offset) {
    return (bytes[offset] << 24) + (bytes[offset+1] << 16) + (bytes[offset+2] << 8) + bytes[offset+3];
}

@interface FPAgent (Private)

- (BOOL)expectMessageType:(short)expectedType forData:(NSData *)data;
- (void)readHello:(NSData *)data;
- (void)readSample;
- (void)readSamples:(NSData *)data;
- (void)readMemoryUsage:(NSData *)data;
- (void)readNextStackFrame;
- (void)completeSample;
- (NSInvocation *)invocationForSelector:(SEL)selector;
- (void)sendCommand:(NSData *)command responseLength:(CFIndex)length withResponder:(NSInvocation *)responder;
- (void)readData:(CFIndex)length withResponder:(NSInvocation *)responder;
- (void)readString:(NSInvocation *)action;
- (void)completeStackFrame:(NSMutableDictionary *)context;

@end

@implementation FPAgent

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithSocket" 
                                 userInfo:nil];
    
    return nil;
}

- (id)initWithSocket:(AsyncSocket *)socket {
    [super init];
    
    _socket = socket; 
    
    [_socket setDelegate:self];
    
    _readCallbacks = [NSMutableDictionary dictionaryWithCapacity:16];
    _writeCallbacks = [NSMutableDictionary dictionaryWithCapacity:16];
    _readId = 0;
    _writeId = 0;
    
    return self;
}

- (BOOL)isConnected {
    return [_socket isConnected];
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"Accepted conection on %@:%i", host, port);
    
    [self readData:12 withResponder:[self invocationForSelector:@selector(readHello:)]];
}

// TODO category on NSData?
- (BOOL)expectMessageType:(short)expectedType forData:(NSData *)data {
    const unsigned char *bytes = [data bytes];
    short msg_type = read_short(bytes, 0);
    
    if( msg_type != expectedType ) {
        // TODO return an error
        NSLog(@"expected message type %i, but got %i", expectedType, msg_type);
        [_socket disconnect];
        return NO;
    }
    
    return YES;
}

- (void)readHello:(NSData *)data {
    if( ![self expectMessageType:0x4201 forData:data] ) {
        return;
    }
    
    const unsigned char *bytes = [data bytes];
    unsigned int seconds = read_unsigned_int(bytes,2);
    short ms = read_short(bytes, 6);
    unsigned int counter = read_unsigned_int(bytes,8);
    
    NSTimeInterval secondsSince1970 = seconds + ((ms - counter) / 1000.0);
    _remoteTime = [NSDate dateWithTimeIntervalSince1970: secondsSince1970];
    
    NSLog(@"Agent Ready. Remote time is %@", _remoteTime);
    
    _samplingState = Stopped;
    
    [_delegate agentConnected:self];    
}

- (void)readMemoryUsage:(NSData *)data {
    if( ![self expectMessageType:0x4203 forData:data] ) {
        return;
    }
    
    const unsigned char *bytes = [data bytes];
    unsigned int offset = read_unsigned_int(bytes,2);
    unsigned int usage = read_unsigned_int(bytes,6);
    
    NSDate *timestamp = [_remoteTime addTimeInterval:offset / 1000.0];
    
    [_delegate memoryUsage:[[FPMemoryUsage alloc] initWithUsage:usage at:timestamp] 
                  forAgent:self];
}

- (void)readSamples:(NSData *)data {
    if( ![self expectMessageType:0x420b forData:data] ) {
        return;
    }

    const unsigned char *bytes = [data bytes];
    _expectedSamples = read_unsigned_int(bytes, 2);
    _sampleSet = [[FPSampleSet alloc] init];

    NSLog(@"will read %lu samples", _expectedSamples);
    
    [self readSample];
}

- (void)readSample {
    NSLog(@"attempting to read sample header");
    [self readData:6 withResponder:[self invocationForSelector:@selector(readSampleHeader:)]];
}

- (void)readStackTrace {
    NSLog(@"Reading stack trace...");
    [self readData:2 withResponder:[self invocationForSelector:@selector(readStackTraceHeader:)]];
}

- (void)readObjectId:(NSData *)data {
    NSUInteger object_id = read_unsigned_int((unsigned char*)[data bytes], 0);
    
    [_currentSampleData setObject:[NSNumber numberWithUnsignedInteger:object_id] forKey:@"object id"];
    
    NSLog(@"Read object ID %lx", object_id);
    
    switch(_currentSampleType) {
        case NewObject:
            [self readString:[self invocationForSelector:@selector(readNewObjectClassName:)]];
            break;
        case DeletedObject:
            [self readData:4 withResponder:[self invocationForSelector:@selector(readObjectSize:)]];
            break;
        default:
            // TODO throw exception
            NSLog(@"Expected to be either a new or deleted object, but was %i", _currentSampleType);
            [_socket disconnect];
            break;
    }
}

- (void)readObjectSize:(NSData *)data {
    NSUInteger size = read_unsigned_int((unsigned char*)[data bytes], 0);
    
    [_currentSampleData setObject:[NSNumber numberWithUnsignedInteger:size] forKey:@"size"];
    
    [self readStackTrace];
}

- (void)readSampleHeader:(NSData *)data {
    const unsigned char *bytes = [data bytes];
    short msg_type = read_short(bytes, 0);
    NSUInteger time = read_unsigned_int(bytes, 2);

    _currentSampleData = [NSMutableDictionary dictionaryWithCapacity:8];

    [_currentSampleData setObject:[_remoteTime addTimeInterval:time / 1000000.0] forKey:@"time"];
    
    switch (msg_type) {
        case 0x4210:
            NSLog(@"Reading new object sample");
            _currentSampleType = NewObject;

            [self readData:4 withResponder:[self invocationForSelector:@selector(readObjectId:)]];
            break;
        case 0x4211:
            NSLog(@"Reading delete object sample");
            _currentSampleType = DeletedObject;

            [self readData:4 withResponder:[self invocationForSelector:@selector(readObjectId:)]];
            break;
        case 0x4212:
            NSLog(@"Reading CPU sample");
            _currentSampleType = CPU;

            [self readStackTrace];
            break;
        default:
            // TODO return an error
            NSLog(@"expected a sample message type but got %i", msg_type);
            [_socket disconnect];
            break;
    }    
}

- (void)completeSample {
    FPSample *sample = nil;
    NSArray *stack = [NSArray arrayWithArray:[_currentSampleData objectForKey:@"stack"]];
    NSDate *at = [_currentSampleData objectForKey:@"time"];
    
    switch( _currentSampleType ) {
        case NewObject:
            sample = [[FPNewObjectSample alloc] initWithIdentifier:[[_currentSampleData objectForKey:@"object id"] unsignedIntegerValue] 
                                                            ofType:[_currentSampleData objectForKey:@"className"] 
                                                        atLocation:stack
                                                                at:at];
            break;
        case DeletedObject:
            sample = [[FPDeleteObjectSample alloc] initWithIdentifier:[[_currentSampleData objectForKey:@"object id"] unsignedIntegerValue] 
                                                                 size:[[_currentSampleData objectForKey:@"size"] unsignedIntegerValue] 
                                                           atLocation:stack 
                                                                   at:at];
            break;
        case CPU:
            sample = [[FPCpuSample alloc] initWithStack:stack at:at];
            break;
    }
    
    NSLog(@"Read %@", sample);
    
    _currentSampleData = nil;
    
    [_sampleSet add:sample];
    
    if( --_expectedSamples == 0 ) {
        NSLog(@"Done reading samples");
        [_delegate samples:_sampleSet forAgent:self];
        _sampleSet = nil;
    } else {
        [self readSample];
    }
}

- (void)readStackTraceHeader:(NSData *)data {
    const unsigned char *bytes = [data bytes];
    
    _expectedStackFrames = read_short(bytes, 0);
    
    NSLog(@"Expecting %i stack frames", _expectedStackFrames);
    
    [_currentSampleData setObject:[NSMutableArray arrayWithCapacity:_expectedStackFrames] forKey:@"stack"];
    
    [self readNextStackFrame];
}

- (void)readNextStackFrame {
    if( _expectedStackFrames == 0 ) {
        NSLog(@"done reading stack");
        [self completeSample];    
    } else {
        NSLog(@"Reading stack frame %i", _expectedStackFrames);
        [self readString:[self invocationForSelector:@selector(readStackFrameFunction:)]];
        --_expectedStackFrames;
    }
}

- (void)readNewObjectClassName:(NSString *)className {
    [_currentSampleData setObject:className forKey:@"className"];
    [self readStackTrace];
}

- (void)readStackFrameFunction:(NSString *)function {
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:3];
    [data setObject:function forKey:@"function"];
    
    NSInvocation *action = [self invocationForSelector:@selector(readStackFrameFile:withContext:)];
    [action setArgument:&data atIndex:3];
    
    [self readString:action];
}

- (void)readStackFrameFile:(NSString *)file withContext:(NSMutableDictionary *)context {
    if( file == nil ) {
        NSLog(@"stack has no file");
        [self completeStackFrame:context];
    } else {
        [context setObject:file forKey:@"file"];
        
        NSInvocation *action = [self invocationForSelector:@selector(readStackFrameLine:withContext:)];
        [action setArgument:&context atIndex:3];
        
        NSLog(@"will read file for stack frame");
        
        [self readData:4 withResponder:action];
    }
}

- (void)readStackFrameLine:(NSData *)data withContext:(NSMutableDictionary *)context {
    NSUInteger line = read_unsigned_int((unsigned char*)[data bytes], 0);
    
    [context setObject:[NSNumber numberWithUnsignedInteger:line] forKey:@"line"];
    [self completeStackFrame:context];
}

- (void)completeStackFrame:(NSMutableDictionary *)context {
    FPStackFrame *frame = [FPStackFrame alloc];
    
    if( nil == [context objectForKey:@"file"] ) {
        [frame initWithFunctionName:[context objectForKey:@"function"]];
    } else {
        [frame initWithFunctionName:[context objectForKey:@"function"] 
                               file:[context objectForKey:@"file"]
                               line:[[context objectForKey:@"line"] unsignedIntValue]];
    }
    
    NSLog(@"Read stack frame %@", frame);
    
    [[_currentSampleData objectForKey:@"stack"] addObject:frame];

    [self readNextStackFrame];
}

- (void)readString:(NSInvocation *)action {
    NSInvocation *response = [self invocationForSelector:@selector(readStringLength:andDo:)];
    
    [response setArgument:&action atIndex:3];
    
    NSLog(@"reading string start");
    
    [self readData:2 withResponder:response];
}

- (void)readStringLength:(NSData *)data andDo:(NSInvocation *)action {
    const unsigned char *bytes = [data bytes];
    short length = read_short(bytes, 0);
    
    NSLog(@"String of length %i", length);
    
    if( length == 0 ) {
        NSString *value = nil;
        [action setArgument:&value atIndex:2];
        [action invoke];
    } else {
        NSInvocation *response = [self invocationForSelector:@selector(readStringBody:andDo:)];
        
        [response setArgument:&action atIndex:3];
        
        NSLog(@"reading body...");
        
        [self readData:length withResponder:response];
    }
}

- (void)readStringBody:(NSData *)data andDo:(NSInvocation *)action {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Invoking invocation with string '%@'", string);
    [action setArgument:&string atIndex:2];
    [action invoke];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    NSLog(@"Socket closed");

    [_delegate agentDisconnected:self withReason:nil];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    NSLog(@"Will be closing due to %@", err);
    
    [_delegate agentDisconnected:self withReason:err];
}

- (void)memoryUsage {
    [self sendCommand:[NSData dataWithBytes:"\x42\x02" length:2] 
       responseLength:10 
        withResponder:[self invocationForSelector:@selector(readMemoryUsage:)]];
}

- (BOOL)isSampling {
    return Stopped != _samplingState;
}

- (IBAction)startSampling {
    [self sendCommand:[NSData dataWithBytes:"\x42\x04" length:2] 
       responseLength:2 
        withResponder:[self invocationForSelector:@selector(startSamplingResponse:)]];
}

- (void)startSamplingResponse:(NSData *)data {
    if( [self expectMessageType:0x4205 forData:data] ) {
        _samplingState = Started;
        [_delegate startedSampling:self];
    }
}

- (IBAction)pauseSampling {
    [self sendCommand:[NSData dataWithBytes:"\x42\x06" length:2] 
       responseLength:2 
        withResponder:[self invocationForSelector:@selector(pauseSamplingResponse:)]];
}

- (void)pauseSamplingResponse:(NSData *)data {
    if( [self expectMessageType:0x4207 forData:data] ) {
        _samplingState = Paused;
        [_delegate pausedSampling:self];
    }
}

- (IBAction)stopSampling {
    [self sendCommand:[NSData dataWithBytes:"\x42\x08" length:2] 
       responseLength:2 
        withResponder:[self invocationForSelector:@selector(stopSamplingResponse:)]];
}

- (void)stopSamplingResponse:(NSData *)data {
    if( [self expectMessageType:0x4209 forData:data] ) {
        _samplingState = Stopped;
        [_delegate stoppedSampling:self];
    }
}

- (void)samples {
    [self sendCommand:[NSData dataWithBytes:"\x42\x0a" length:2] 
       responseLength:6 
        withResponder:[self invocationForSelector:@selector(readSamples:)]];
}

- (void)sendCommand:(NSData *)command responseLength:(CFIndex)length withResponder:(NSInvocation *)responder {
    NSInvocation *invocation = [self invocationForSelector:@selector(readData:withResponder:)];

    [invocation setArgument:&length atIndex:2];
    [invocation setArgument:&responder atIndex:3];
    
    long id = _writeId++;
    
//    NSLog(@"Sending %@ as id %li", command, id);
    
    [_writeCallbacks setObject:invocation forKey:[NSNumber numberWithLong:id]];
    [_socket writeData:command withTimeout:5 tag:id];        
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSNumber *key = [NSNumber numberWithLong:tag];
    NSInvocation *callback = [_writeCallbacks objectForKey:key];
    
    if( nil == callback ) {
        NSLog(@"ERROR no callback for write key %li", tag);
    } else {
//        NSLog(@"Wrote %@ for %li", callback, tag);
        [callback invoke];
        [_writeCallbacks removeObjectForKey:key];
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSNumber *key = [NSNumber numberWithLong:tag];
    NSInvocation *callback = [_readCallbacks objectForKey:key];
    
    if( nil == callback ) {
        NSLog(@"ERROR no callback for read key %li", tag);
    } else {
//        NSLog(@"Read %@ for %li", callback, tag);
        [callback setArgument:&data atIndex:2];
        [callback invoke];
        [_readCallbacks removeObjectForKey:key];
    }
}

// the invocation should expect the NSData to be its first argument
- (void)readData:(CFIndex)length withResponder:(NSInvocation *)responder {
    long id = _readId++;
    
//    NSLog(@"Reading for id %li %li bytes", id, length);
    
    [_readCallbacks setObject:responder forKey:[NSNumber numberWithLong:id]];
    [_socket readDataToLength:length withTimeout:5 tag:id];
}

- (NSInvocation *)invocationForSelector:(SEL)selector {
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation setTarget:self];
    [invocation setSelector:selector];

    return invocation;
}

@end
