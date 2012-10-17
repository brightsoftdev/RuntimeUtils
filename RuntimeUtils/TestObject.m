//
//  TestObject.m
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject

- (void)dealloc
{
    self.stringValue = nil;
    [_readonly release];
    self.retain = nil;
    self.assign = nil;
    [super dealloc];
}

@end
