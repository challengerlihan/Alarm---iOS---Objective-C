//
//  AppDelegate.m
//  Alarm
//
//  Created by Han Li on 15/4/9.
//  Copyright (c) 2015年 Han Li. All rights reserved.
//

#import "AppDelegate.h"
#import "DataModel.h"
#import "AlarmListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MMPDeepSleepPreventer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    DataModel *_dataModel;
    MMPDeepSleepPreventer *deepSleepPreventer;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    _dataModel = [[DataModel alloc]init];
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    AlarmListViewController *controller = navigationController.viewControllers[0];
    controller.dataModel = _dataModel;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    deepSleepPreventer = [[MMPDeepSleepPreventer alloc]init];
    [deepSleepPreventer startPreventSleep];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [_dataModel saveAlarms];
    deepSleepPreventer = [[MMPDeepSleepPreventer alloc]init];
    [deepSleepPreventer startPreventSleep];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [_dataModel saveAlarms];
}

@end
