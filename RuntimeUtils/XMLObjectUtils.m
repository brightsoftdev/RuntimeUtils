//
//  XMLObjectUtils.m
//  GewaraSport
//
//  Created by yangzexin on 12-10-15.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "XMLObjectUtils.h"
#import <objc/runtime.h>
#import "RuntimeUtils.h"
#import "RTProperty.h"

@interface XMLObjectUtils ()

@property(nonatomic, retain)id<XMLObjectPropertyMapping> propertyMapping;

@end

@implementation XMLObjectUtils

@synthesize replaceMapping;
@synthesize propertyMapping;

- (void)dealloc
{
    self.replaceMapping = nil;
    self.propertyMapping = nil;
    [super dealloc];
}

+ (id)createWithReplaceMapping:(ReplaceMappingBlock)replaceMapping
{
    return [[[XMLObjectUtils alloc] initWithReplaceMapping:replaceMapping] autorelease];
}

+ (id)createWithPropertyMapping:(id<XMLObjectPropertyMapping>)propertyMapping
{
    return [[[XMLObjectUtils alloc] initWithPropertyMapping:propertyMapping] autorelease];
}

- (id)init
{
    self = [super init];
    
    return self;
}

- (id)initWithReplaceMapping:(ReplaceMappingBlock)pReplaceMapping
{
    self = [self init];
    
    self.replaceMapping = pReplaceMapping;
    
    return self;
}

- (id)initWithPropertyMapping:(id<XMLObjectPropertyMapping>)pPropertyMapping
{
    self = [self init];
    
    self.propertyMapping = pPropertyMapping;
    
    return self;
}

- (id)objectWithClass:(Class)objClass parentTBXMLElement:(TBXMLElement *)parentElement
{
    id tmpObject = [[[objClass alloc] init] autorelease];
    unsigned int property_count = 0;
    objc_property_t *property_list = class_copyPropertyList(objClass, &property_count);
    
    RTProperty *tmpProperty = [[[RTProperty alloc] init] autorelease];
    
    for(NSInteger i = 0; i < property_count; ++i){
        [tmpProperty setObjc_property:*(property_list + i)];
        
        NSString *propertyName = tmpProperty.name;
        NSString *elementName = propertyName;
        if(self.propertyMapping){
            NSString *targetElementName = [self.propertyMapping XMLElementNameForPropertyName:propertyName];
            if(targetElementName.length != 0){
                elementName = targetElementName;
            }
        }
        if(self.replaceMapping){
            // 通过block来确定对象的property name对应的xml element name
            NSString *targetElementName = self.replaceMapping(propertyName, objClass);
            if(targetElementName.length != 0){
                elementName = targetElementName;
            }
        }
        TBXMLElement *tmpElement = [TBXML childElementNamed:elementName parentElement:parentElement];
        NSString *value = [TBXML textForElement:tmpElement];
        if(value.length == 0){
            value = @"";
        }
        [tmpProperty setWithString:value targetObject:tmpObject];
    }
    
    return tmpObject;
}

- (id)objectListWithClass:(Class)objClass firstTBXMLElement:(TBXMLElement *)firstElement
{
    NSMutableArray *objList = [NSMutableArray array];
    while(firstElement){
        id tmpObj = [self objectWithClass:objClass parentTBXMLElement:firstElement];
        [objList addObject:tmpObj];
        
        firstElement = firstElement->nextSibling;
    }
    return objList;
}

+ (id)objectListWithParentElement:(TBXMLElement *)parentElement
                     classDecider:(TargetClassDeciderBlock)classDecider
           propertyMappingDecider:(TargetPropertyMappingDeciderBlock)propertyMappingDecider
{
    return [self objectListWithParentElement:parentElement
                                classDecider:classDecider
                      propertyMappingDecider:propertyMappingDecider
                              replaceMapping:nil];
}

+ (id)objectListWithParentElement:(TBXMLElement *)parentElement
                     classDecider:(TargetClassDeciderBlock)classDecider
           propertyMappingDecider:(TargetPropertyMappingDeciderBlock)propertyMappingDecider
                   replaceMapping:(ReplaceMappingBlock)replaceMapping
{
    NSMutableArray *objList = [NSMutableArray array];
    TBXMLElement *childElement = parentElement->firstChild;
    while(childElement){
        NSString *elementName = [NSString stringWithUTF8String:childElement->name];
        Class targetClass = classDecider(elementName);
        id<XMLObjectPropertyMapping> propertyMapping = propertyMappingDecider(elementName);
        XMLObjectUtils *objUtils = [XMLObjectUtils createWithPropertyMapping:propertyMapping];
        objUtils.replaceMapping = replaceMapping;
        id tmpObj = [objUtils objectWithClass:targetClass parentTBXMLElement:childElement];
        [objList addObject:tmpObj];
        
        childElement = childElement->nextSibling;
    }
    return objList;
}

+ (NSString *)descriptionOfObject:(id<NSObject>)obj
{
    return [RuntimeUtils descriptionOfObject:obj];
}

+ (NSString *)descriptionOfObjectList:(NSArray *)objList
{
    return [RuntimeUtils descriptionOfObjectList:objList];
}

@end
