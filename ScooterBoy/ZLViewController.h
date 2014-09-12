//
//  ZLViewController.h
//  ScooterBoy
//

//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "ZLMyScene.h"
#import "ZLMainScene.h"
#import "ZLAlertView.h"
#import <GameKit/GameKit.h>

@interface ZLViewController : UIViewController<ZLAlertViewDelegate,GKGameCenterControllerDelegate>
{
    BOOL   bShowAlertView;
   // UIButton   *btnGameCenter;
}
@property(nonatomic,retain)NSArray                   *mHomeTask;
@property(nonatomic,retain)NSArray                   *mSchoolTask;
@property(nonatomic,retain)NSArray                   *mHospitalTask;
@property(nonatomic,retain)NSArray                   *mStoreTask;
@property(nonatomic,retain)ZLMyScene               *mPortraitScene;
@property(nonatomic,retain)ZLMainScene              *mLandscapeScene;
@end
