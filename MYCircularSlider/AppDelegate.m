//
//  AppDelegate.m
//  MYCircularSlider
//
//  Created by Sehaj Chawla on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize controller = _controller;
@synthesize backgroundTime = _backgroundTime;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:UIStatusBarAnimationSlide];
    // Override point for customization after application launch.
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
     //                                                        bundle: nil];
    //self.controller = (ViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"mainscreen"];
    self.controller = (ViewController *)[self.window rootViewController];
    //UITabBarController *tabBar = (UITabBarController *)[self.window rootViewController];
    //self.controller = [[tabBar viewControllers] objectAtIndex:1];
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
    if (!self.controller.isPaused) {
        [self.controller fireLocalNotification:self.controller.timeLeft];
        self.backgroundTime = [NSDate date];
    }
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if (!self.controller.isPaused) {
        self.controller.timeElapsed = self.controller.timeElapsed + [[NSDate date] timeIntervalSinceDate:self.backgroundTime];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Received a local notification");
    
}

@end
