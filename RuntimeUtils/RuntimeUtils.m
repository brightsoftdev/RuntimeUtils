//
//  RuntimeUtils.m
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "RuntimeUtils.h"
#import <objc/runtime.h>

@implementation RuntimeUtils

+ (SEL)selectorForSetterWithPropertyName:(NSString *)propertyName
{
    if(propertyName.length > 1){
        NSString *firstLetter = [propertyName substringToIndex:1];
        firstLetter = [firstLetter uppercaseString];
        NSString *methodName = [NSString stringWithFormat:@"set%@%@:", firstLetter, [propertyName substringFromIndex:1]];
        return NSSelectorFromString(methodName);
    }
    return nil;
}

+ (void)invokePropertySetterWithTargetObject:(id<NSObject>)object propertyName:(NSString *)propertyName value:(void *)value
{
    SEL targetSelector = [self.class selectorForSetterWithPropertyName:propertyName];
    if([object respondsToSelector:targetSelector]){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object.class instanceMethodSignatureForSelector:targetSelector]];
        invocation.target = object;
        invocation.selector = targetSelector;
        [invocation setArgument:value atIndex:2];
        [invocation invoke];
    }
}

+ (NSString *)descriptionOfObject:(id<NSObject>)obj
{
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%@{", NSStringFromClass(obj.class)];
    
    unsigned int property_count = 0;
    objc_property_t *property_list = class_copyPropertyList(obj.class, &property_count);
    for(NSInteger i = 0; i < property_count; ++i){
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(*(property_list + i))];
        NSString *propertyAttri = [NSString stringWithUTF8String:property_getAttributes(*(property_list + i))];
        
        if([propertyAttri hasPrefix:@"T@"]){
            SEL targetSEL = NSSelectorFromString(propertyName);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[obj.class instanceMethodSignatureForSelector:targetSEL]];
            [invocation setSelector:targetSEL];
            [invocation setTarget:obj];
            [invocation invoke];
            id value;
            [invocation getReturnValue:&value];
            if([value rangeOfString:@"\n"].location != NSNotFound){
                [desc appendFormat:@"[%@]:%@\n", propertyName, value];
            }else{
                [desc appendFormat:@"[%@]:%@\t", propertyName, value];
            }
        }
    }
    [desc appendString:@"}"];
    
    return desc;
}

+ (NSString *)descriptionOfObjectList:(NSArray *)objList
{
    NSMutableString *desc = [NSMutableString stringWithString:@"\n"];
    
    for(id<NSObject> obj in objList){
        [desc appendFormat:@"%@\n\n", [self.class descriptionOfObject:obj]];
    }
    [desc appendString:@"\n"];
    
    return desc;
}

@end
