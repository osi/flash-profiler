//
//  main.m
//  FlashProfilerApp
//
//  Created by peter royal on 12/24/08.
//  Copyright Peter Royal 2008-2009. All rights reserved.
//

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
