//
//  XMLObjectUtils.h
//  GewaraSport
//
//  Created by yangzexin on 12-10-15.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@protocol XMLObjectPropertyMapping;

/** 
 return element name mapping in xml elemnt 
 */
typedef NSString *(^ReplaceMappingBlock)(NSString *propertyName, Class targetClass);
/**
 return target class for encountered element name
 */
typedef Class(^TargetClassDeciderBlock)(NSString *elementName);
/**
 return XMLObjectPropertyMapping for encountered element name
 */
typedef id<XMLObjectPropertyMapping>(^TargetPropertyMappingDeciderBlock)(NSString *elementName);

@protocol XMLObjectPropertyMapping <NSObject>

- (NSString *)XMLElementNameForPropertyName:(NSString *)propertyName;

@end

@interface XMLObjectUtils : NSObject

@property(nonatomic, copy)ReplaceMappingBlock replaceMapping;

+ (id)createWithReplaceMapping:(ReplaceMappingBlock)replaceMapping;
+ (id)createWithPropertyMapping:(id<XMLObjectPropertyMapping>)propertyMapping;

- (id)init;
- (id)initWithReplaceMapping:(ReplaceMappingBlock)replaceMapping;
- (id)initWithPropertyMapping:(id<XMLObjectPropertyMapping>)propertyMapping;

- (id)objectWithClass:(Class)objClass parentTBXMLElement:(TBXMLElement *)parentElement;
- (id)objectListWithClass:(Class)objClass firstTBXMLElement:(TBXMLElement *)firstElement;

+ (id)objectListWithParentElement:(TBXMLElement *)parentElement
                     classDecider:(TargetClassDeciderBlock)classDecider
           propertyMappingDecider:(TargetPropertyMappingDeciderBlock)propertyMappingDecider;
+ (id)objectListWithParentElement:(TBXMLElement *)parentElement
                     classDecider:(TargetClassDeciderBlock)classDecider
           propertyMappingDecider:(TargetPropertyMappingDeciderBlock)propertyMappingDecider
                   replaceMapping:(ReplaceMappingBlock)replaceMapping;

+ (NSString *)descriptionOfObject:(id<NSObject>)obj;
+ (NSString *)descriptionOfObjectList:(NSArray *)objList;

@end
