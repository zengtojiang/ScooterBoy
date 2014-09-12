//
//  ZLAppDelegate.m
//  Skiing Boy
//
//  Created by libs on 14-3-17.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLAppDelegate.h"

@implementation ZLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //exit(0);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    //exit(0);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initAudioPlayer
{
    mAudioPlayer=[[ZLAudioPlayer alloc] init];
    [mAudioPlayer setBackgroundAudioFileName:@"background3" fileType:@"mp3"];
}

-(void)startBGAudio
{
    if (!mAudioPlayer) {
        [self initAudioPlayer];
    }
    [mAudioPlayer play];
}

-(void)stopBGAudio
{
    [mAudioPlayer stop];
}

@end
