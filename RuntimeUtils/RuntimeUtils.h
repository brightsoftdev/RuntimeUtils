//
//  RuntimeUtils.h
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeUtils : NSObject

+ (SEL)selectorForSetterWithPropertyName:(NSString *)propertyName;

+ (void)invokePropertySetterWithTargetObject:(id<NSObject>)object propertyName:(NSString *)name value:(void *)value;

+ (NSString *)descriptionOfObject:(id<NSObject>)obj;
+ (NSString *)descriptionOfObjectList:(NSArray *)objList;

@end
