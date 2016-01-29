//
//  DJAppDelegate.m
//  RoastApp
//
//  Created by Darren Jennings on 11/16/13.
//  Copyright (c) 2013 Darren Jennings. All rights reserved.
//
#import "DJMasterViewController.h"
#import "DJAppDelegate.h"
#import "TimerLogDoc.h"
#import "TimerLogDatabase.h"

@implementation DJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSMutableArray *LoadedLogs = [TimerLogDatabase loadTimerLogDocs];

    UITabBarController * tabController = (UITabBarController *) self.window.rootViewController;
    UINavigationController * navController = [tabController.viewControllers objectAtIndex:0];
    DJMasterViewController * masterController = [navController.viewControllers objectAtIndex:0];
    [masterController setEvents:LoadedLogs];
    
    
    /* file managing... */
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory
                                        inDomains:NSUserDomainMask];
    
    if ([urls count] > 0){
        NSURL *documentsFolder = urls[0];
        NSLog(@"%@", documentsFolder);
    } else {
        NSLog(@"Could not find the Documents folder.");
    }
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:189/255.0 green:195/255.0 blue:199/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

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
