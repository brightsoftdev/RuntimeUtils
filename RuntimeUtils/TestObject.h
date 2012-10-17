//
//  TestObject.h
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestObject : NSObject

@property(nonatomic, assign)float floatValue;
@property(nonatomic, copy)NSString *stringValue;
@property(nonatomic, readonly)NSString *readonly;
@property(nonatomic, retain)NSString *retain;
@property(nonatomic, assign)NSString *assign;
@property(nonatomic, assign)NSInteger intvalue;
@property(nonatomic, assign)long longValue;
@property(nonatomic, assign)BOOL boolValue;
@property(nonatomic, assign)signed char C;
@property(nonatomic, assign)bool b;

@end
