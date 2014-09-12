//
//  ZLAppDelegate.h
//  Skiing Boy
//
//  Created by libs on 14-3-17.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLAudioPlayer.h"

@interface ZLAppDelegate : UIResponder <UIApplicationDelegate>
{
    ZLAudioPlayer   *mAudioPlayer;
}
@property (strong, nonatomic) UIWindow *window;
-(void)startBGAudio;

-(void)stopBGAudio;
@end
