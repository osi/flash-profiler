//
//  OneToTrueValueTransformer.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/11/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "NonZeroLengthArrayValueTransformer.h"


@implementation NonZeroLengthArrayValueTransformer

+ (Class)transformedValueClass {
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    BOOL result = [value count] > 0 ? YES : NO;
    
    return [NSNumber numberWithBool:result];
}

@end
