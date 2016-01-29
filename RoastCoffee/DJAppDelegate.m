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
#import "DJSettingsDoc.h"
#import "DJSettings.h"
#import "DJSettingsViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@implementation DJAppDelegate
// Check if device is iPhone 5
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
// Get the storyboard name according to the device
#define GET_STORYBOARD_NAME(controllerName) IS_IPHONE_5 ? controllerName : [NSString stringWithFormat:@"%@_iPhone4",controllerName]

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    UITabBarController * tabController = (UITabBarController *) self.window.rootViewController;
    
    //iphone 3.5 screen size
    if (iOSDeviceScreenSize.height == 480)
    {
        UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];

        tabController = [iPhone35Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = tabController;

    }
    
    //iphone 4.0 screen size
    if (iOSDeviceScreenSize.height >= 568 || [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone4" bundle:nil];
        
        tabController = [iPhone4Storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = tabController;
    }
    /*if(iOSDeviceScreenSize.height > 568)
    {
        UIStoryboard *iPhoneIpadStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone4" bundle:nil];
        
        tabController = [iPhoneIpadStoryboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = tabController;
    }*/
    
    NSMutableArray *LoadedLogs = [TimerLogDatabase loadTimerLogDocs];
    
    NSMutableArray *sttings = [DJSettingsDoc loadSettings];
    
    UINavigationController * navController1 = [tabController.viewControllers objectAtIndex:0];
    UINavigationController * navController2 = [tabController.viewControllers objectAtIndex:1];
    DJMasterViewController * masterController = [navController1.viewControllers objectAtIndex:0];
    DJSettingsViewController *settingsController =[navController2.viewControllers objectAtIndex:0];
    
    DJSettingsDoc* sttgs1 = [sttings objectAtIndex:0];
    
    [masterController setEvents:LoadedLogs];
    [masterController setTheSettings:sttgs1];
    [settingsController setTehSettings:sttgs1];
    
    
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
    navController1.navigationBar.translucent = false;
    navController2.navigationBar.translucent = false;
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:189/255.0 green:195/255.0 blue:199/255.0 alpha:1.0]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:197/255.0 green:57/255.0 blue:43/255.0 alpha:1.0] ];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    navController1.tabBarItem.image = [UIImage imageNamed:@"document9.png"];
    
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"frcrixoh8gb58ga"
                            appSecret:@"1umw9b5844iw307"
                            root:kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
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
