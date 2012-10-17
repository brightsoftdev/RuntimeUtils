//
//  RTProperty.m
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "RTProperty.h"
#import "RuntimeUtils.h"

@interface RTProperty ()

@property(nonatomic, copy)NSString *attributes;
@property(nonatomic, copy)NSString *objectTypeName;

@end

@implementation RTProperty

@synthesize name;
@synthesize type;
@synthesize accessType;
@synthesize attributes;
@synthesize objectTypeName;

- (void)dealloc
{
    self.name = nil;
    self.attributes = nil;
    self.objectTypeName = nil;
    [super dealloc];
}

- (id)initWithName:(NSString *)name attributes:(NSString *)pAttributes
{
    self = [super init];
    
    self.attributes = pAttributes;
    NSArray *attributeList = [self.attributes componentsSeparatedByString:@","];
    if(attributeList.count > 1){
        self.type = [self.class typeOfDesc:[attributeList objectAtIndex:0]];
        if(self.type == RTPropertyTypeObject){
            self.objectTypeName = [self.class objectTypeNameOfDesc:[attributeList objectAtIndex:0]];
        }
        self.accessType = [self.class accessTypeOfDesc:[attributeList objectAtIndex:1]];
    }
    
    return self;
}

- (void)setValue:(NSString *)value targetObject:(id<NSObject>)obj
{
    NSString *propertyName = self.name;
    RTPropertyType ptype = self.type;
    if(ptype != RTPropertyTypeUnknown){
        if(ptype == RTPropertyTypeArray){
        }else if(ptype == RTPropertyTypeBit){
            // no implementation
        }else if(ptype == RTPropertyTypeBOOL){
            BOOL b = [value boolValue];
            value = [value lowercaseString];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(!b && [value isEqualToString:@"true"]){
                b = YES;
            }
            if(!b && [value isEqualToString:@"yes"]){
                b = YES;
            }
            if(!b && [value isEqualToString:@"1"]){
                b = YES;
            }
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&b];
        }else if(ptype == RTPropertyTypeChar){
            unsigned char ch = [value characterAtIndex:0];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&ch];
        }else if(ptype == RTPropertyTypeCharPoint){
            // no implementation
        }else if(ptype == RTPropertyTypeClass){
            Class class = NSClassFromString(value);
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&class];
        }else if(ptype == RTPropertyTypeDouble){
            double d = [value doubleValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&d];
        }else if(ptype == RTPropertyTypeFloat){
            float f = [value floatValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&f];
        }else if(ptype == RTPropertyTypeInt){
            int i = [value intValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&i];
        }else if(ptype == RTPropertyTypeLong){
            long l = [value longLongValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&l];
        }else if(ptype == RTPropertyTypeLongLong){
            long long l = [value longLongValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&l];
        }else if(ptype == RTPropertyTypeObject){
            if([self.objectTypeName isEqualToString:@"NSString"]){
                [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&value];
            }else{
                // no implementation
            }
        }else if(ptype == RTPropertyTypePointerToType){
            void *pointer = value;
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&pointer];
        }else if(ptype == RTPropertyTypeSEL){
            // no implementation
        }else if(ptype == RTPropertyTypeShort){
            short s = [value intValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&s];
        }else if(ptype == RTPropertyTypeStructure){
            // no implementation
        }else if(ptype == RTPropertyTypeUnion){
            // no implementation
        }else if(ptype == RTPropertyTypeUnknown){
            // no implementation
        }else if(ptype == RTPropertyTypeUnsignedChar){
            unsigned char c = [value characterAtIndex:0];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&c];
        }else if(ptype == RTPropertyTypeUnsignedInt){
            unsigned int i = [value intValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&i];
        }else if(ptype == RTPropertyTypeUnsignedLong){
            long l = [value longLongValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&l];
        }else if(ptype == RTPropertyTypeUnsignedLongLong){
            long long l = [value longLongValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&l];
        }else if(ptype == RTPropertyTypeUnsignedShort){
            unsigned short s = [value intValue];
            [RuntimeUtils invokePropertySetterWithTargetObject:obj propertyName:propertyName value:&s];
        }else if(ptype == RTPropertyTypeVoid){
            // no implementation
        }
    }
}

- (NSString *)getValueFromTargetObject:(id<NSObject>)obj
{
    return nil;
}

+ (RTPropertyAccessType)accessTypeOfDesc:(NSString *)desc
{
    if(desc.length == 1){
        return [desc isEqualToString:@"R"] ? RTPropertyAccessTypeReadOnly : RTPropertyAccessTypeReadWrite;
    }
    return RTPropertyAccessTypeReadOnly;
}

+ (RTPropertyType)typeOfDesc:(NSString *)desc
{
    if([desc hasPrefix:@"T"] && desc.length > 1){
        const unsigned char ctype = [desc characterAtIndex:1];
        switch(ctype){
            case 'c':
                return RTPropertyTypeChar;
            case 'i':
                return RTPropertyTypeInt;
            case 's':
                return RTPropertyTypeShort;
            case 'l':
                return RTPropertyTypeLong;
            case 'q':
                return RTPropertyTypeLongLong;
            case 'C':
                return RTPropertyTypeUnsignedChar;
            case 'I':
                return RTPropertyTypeUnsignedInt;
            case 'S':
                return RTPropertyTypeUnsignedShort;
            case 'L':
                return RTPropertyTypeUnsignedLong;
            case 'Q':
                return RTPropertyTypeUnsignedLongLong;
            case 'f':
                return RTPropertyTypeFloat;
            case 'd':
                return RTPropertyTypeDouble;
            case 'B':
                return RTPropertyTypeBOOL;
            case 'v':
                return RTPropertyTypeVoid;
            case '*':
                return RTPropertyTypeCharPoint;
            case '@':
                return RTPropertyTypeObject;
            case '#':
                return RTPropertyTypeClass;
            case ':':
                return RTPropertyTypeSEL;
            case '[':
                return RTPropertyTypeArray;
            case '{':
                return RTPropertyTypeStructure;
            case '(':
                return RTPropertyTypeUnion;
            case 'b':
                return RTPropertyTypeBit;
            case '^':
                return RTPropertyTypePointerToType;
            case '?':
                return RTPropertyTypeUnknown;
            default:
                return RTPropertyTypeUnknown;
        }
    }
    return RTPropertyTypeUnknown;
}

+ (NSString *)objectTypeNameOfDesc:(NSString *)desc
{
    NSRange tmpRange = [desc rangeOfString:@"\""];
    if(tmpRange.location != NSNotFound){
        ++tmpRange.location;
        int startLocation = tmpRange.location;
        tmpRange.length = desc.length - tmpRange.location;
        tmpRange = [desc rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:tmpRange];
        if(tmpRange.location != NSNotFound){
            NSString *objectType = [desc substringWithRange:NSMakeRange(startLocation, tmpRange.location - startLocation)];
            return objectType;
        }
    }
    return nil;
}


@end
