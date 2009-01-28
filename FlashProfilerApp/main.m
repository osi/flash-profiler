//
//  main.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/6/09.
//  Copyright Peter Royal 2009 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ExceptionHandling/ExceptionHandling.h>

int main(int argc, char *argv[])
{
    [[NSExceptionHandler defaultExceptionHandler] setExceptionHandlingMask:NSLogAndHandleEveryExceptionMask];
    return NSApplicationMain(argc, (const char **) argv);
}
