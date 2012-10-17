//
//  RTProperty.h
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    RTPropertyTypeObject,
    RTPropertyTypeChar,
    RTPropertyTypeInt,
    RTPropertyTypeShort,
    RTPropertyTypeLong,
    RTPropertyTypeLongLong,
    RTPropertyTypeUnsignedChar,
    RTPropertyTypeUnsignedInt,
    RTPropertyTypeUnsignedShort,
    RTPropertyTypeUnsignedLong,
    RTPropertyTypeUnsignedLongLong,
    RTPropertyTypeFloat,
    RTPropertyTypeDouble,
    RTPropertyTypeBOOL,
    RTPropertyTypeVoid,
    RTPropertyTypeCharPoint,
    RTPropertyTypeClass,
    RTPropertyTypeSEL,
    RTPropertyTypeArray,
    RTPropertyTypeStructure,
    RTPropertyTypeUnion,
    RTPropertyTypeBit,
    RTPropertyTypePointerToType,
    RTPropertyTypeUnknown,
}RTPropertyType;

typedef enum{
    RTPropertyAccessTypeReadOnly,
    RTPropertyAccessTypeReadWrite,
}RTPropertyAccessType;

@interface RTProperty : NSObject

- (id)initWithName:(NSString *)name attributes:(NSString *)attributes;

@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)RTPropertyType type;
@property(nonatomic, assign)RTPropertyAccessType accessType;

- (void)setValue:(NSString *)value targetObject:(id<NSObject>)obj;
- (NSString *)getValueFromTargetObject:(id<NSObject>)obj;

@end
