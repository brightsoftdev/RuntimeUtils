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
#import "TestObj.h"

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
        
        RTProperty *p = [[[RTProperty alloc] initWithProperty:tmpProperty] autorelease];
        [p setWithString:@"sds32\t21\t232\n13s\nwqw测试" targetObject:obj];
        NSLog(@"%@:%@", p.name, [p getStringFromTargetObject:obj]);
    }
    
    NSLog(@"%@", obj);
    NSLog(@"%@", [RuntimeUtils descriptionOfObject:obj]);
    
    TestObj *tobj = [[[TestObj alloc] init] autorelease];
    NSLog(@"%@", [RuntimeUtils descriptionOfObject:tobj]);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"test\n\nse\nt", @"test",
                          @"test\n\nse\nt", @"test",
                          @"test\n\nse\nt", @"test", 
                          nil];
    NSLog(@"%@", dict);
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
