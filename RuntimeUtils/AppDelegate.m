//
//  AppDelegate.m
//  RuntimeUtils
//
//  Created by yangzexin on 12-10-17.
//  Copyright (c) 2012年 gewara. All rights reserved.
//

#import "AppDelegate.h"
#import "TestObject.h"
#import <objc/runtime.h>
#import "RuntimeUtils.h"
#import "RTProperty.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    TestObject *obj = [[TestObject new] autorelease];
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(TestObject.class, &propertyCount);
    for(NSInteger i = 0; i < propertyCount; ++i){
        objc_property_t tmpProperty = *(propertyList + i);
        const char *tmpPropertyAttri = property_getAttributes(tmpProperty);
//        NSLog(@"%s", tmpPropertyAttri);
        
        RTProperty *p = [[[RTProperty alloc] initWithName:[NSString stringWithUTF8String:property_getName(tmpProperty)]
                                              attributes:[NSString stringWithUTF8String:tmpPropertyAttri]] autorelease];
        [p setValue:@"false" targetObject:obj];
        NSLog(@"%@:%@", p.name, [p getValueFromTargetObject:obj]);
    }
    
    NSLog(@"%@", obj);
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
