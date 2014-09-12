//
//  ZLViewController.m
//  ScooterBoy
//
//  Created by libs on 14-3-15.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLViewController.h"
#import "ZLHistoryManager.h"
#import "ZLAppDelegate.h"
#import "HSStretchableButton.h"


#define GAMECENTER_ALERTVIEW_TAG   1000
#define TAP_BUILDING_ALERTVIEW_TAG  2000
@implementation ZLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;//YES;
    skView.showsNodeCount = NO;//YES;
    
    UIInterfaceOrientation currentOrientation=self.interfaceOrientation;
    if (UIInterfaceOrientationIsLandscape(currentOrientation)) {
        // Create and configure the scene.
        ZLMainScene * scene = [ZLMainScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        self.mLandscapeScene=scene;
    }else{
        // Create and configure the scene.
        ZLMyScene * scene = [ZLMyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        self.mPortraitScene=scene;
    }
    if ([ZLHistoryManager musicOpened]) {
        [(ZLAppDelegate *)([UIApplication sharedApplication].delegate) startBGAudio];
    }
    
    [self registerNotification];
    /*
    btnGameCenter = [UIButton buttonWithType:UIButtonTypeCustom];
    float buttonWidth=50;
    float buttonMargin=15;
    //[btnGameCenter setFrame:CGRectMake(self.view.frame.size.width-60, 25, image.size.width,image.size.height)];
    [btnGameCenter setFrame:CGRectMake(self.view.frame.size.width-buttonMargin-buttonWidth, buttonMargin, buttonWidth,buttonWidth)];
    [btnGameCenter setImage:[UIImage imageNamed:@"gamecenter1.png"] forState:UIControlStateNormal];
    [btnGameCenter addTarget:self action:@selector(onTapGameCenter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGameCenter];
    if (UIInterfaceOrientationIsLandscape(currentOrientation)){
        btnGameCenter.hidden=YES;
    }else{
        btnGameCenter.hidden=NO;
    }
    */
    [self setGameCenterAuthontication];
}

#pragma mark - gamekit

-(void)setGameCenterAuthontication
{
    [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *viewcontroll, NSError *error) {
        if (viewcontroll) {
            [self presentViewController:viewcontroll animated:YES completion:^{
                
            }];
        }
    }];
    
}

-(void)onTapGameCenter
{
    bShowAlertView=YES;
   // btnGameCenter.enabled=NO;
    ((SKView *)self.view).paused = YES;
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        //        [[GKLocalPlayer localPlayer] setDefaultLeaderboardIdentifier:ZL_DEFAULT_GAMECENTER_LEADERBOARD_IDENTIFIER completionHandler:^(NSError *error){
        //
        //        }];
        GKGameCenterViewController *gameVC=[[GKGameCenterViewController alloc] init];
        //gameVC.viewState=GKGameCenterViewControllerStateLeaderboards;
        gameVC.viewState=GKGameCenterViewControllerStateDefault;
        gameVC.gameCenterDelegate=self;
        //gameVC.leaderboardIdentifier=ZL_DEFAULT_GAMECENTER_LEADERBOARD_IDENTIFIER;
        [self presentViewController:gameVC animated:YES completion:NULL];
    }else{
        // [self setGameCenterAuthontication];
        ZLAlertView *alertView=[[ZLAlertView alloc] initWithMessage:NSLocalizedString(@"Please login game center first", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) confirmButtonTitles:nil];
        alertView.tag=GAMECENTER_ALERTVIEW_TAG;
        [alertView show];
        
    }
}

-(void)resetGameCenterStatus
{
    bShowAlertView=NO;
    ((SKView *)self.view).paused = NO;
}

#pragma mark - @protocol GKGameCenterControllerDelegate <NSObject>

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self resetGameCenterStatus];
    }];
}

#pragma mark - rotation
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        ZLTRACE(@"");
        if (bShowAlertView) {
            return UIInterfaceOrientationMaskPortrait;
        }else{
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        if (self.mPortraitScene) {
            self.mPortraitScene.paused=YES;
        }
    }else{
        if (self.mLandscapeScene) {
            self.mLandscapeScene.paused=YES;
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UIInterfaceOrientation currentOrientation=self.interfaceOrientation;
    if (UIInterfaceOrientationIsLandscape(currentOrientation)) {
        if (!self.mLandscapeScene) {
            ZLMainScene * scene = [ZLMainScene sceneWithSize:self.view.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [(SKView *)self.view presentScene:scene];
            self.mLandscapeScene=scene;
        }else{
            [(SKView *)self.view presentScene:self.mLandscapeScene];
            self.mLandscapeScene.paused=NO;
        }
    //    btnGameCenter.hidden=YES;
    }else{
        if (!self.mPortraitScene) {
            ZLMyScene * scene = [ZLMyScene sceneWithSize:self.view.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [(SKView *)self.view presentScene:scene];
            self.mPortraitScene=scene;
        }else{
            [(SKView *)self.view presentScene:self.mPortraitScene];
            self.mPortraitScene.paused=NO;
        }
      //  btnGameCenter.hidden=NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(NSString *)createNodeTaskForType:(ZLPathNodeType)nodeType
{
    NSArray *taskArray=nil;
    if (nodeType==ZLPathNodeHome) {
        if (self.mHomeTask==nil) {
            NSString *path=[[NSBundle mainBundle] pathForResource:@"hometask" ofType:@"plist"];
            self.mHomeTask=[NSArray arrayWithContentsOfFile:path];
        }
        taskArray=self.mHomeTask;
    }else if (nodeType==ZLPathNodeSchool) {
        if (self.mSchoolTask==nil) {
            NSString *path=[[NSBundle mainBundle] pathForResource:@"schooltask" ofType:@"plist"];
            self.mSchoolTask=[NSArray arrayWithContentsOfFile:path];
        }
       taskArray=self.mSchoolTask;
    }else if (nodeType==ZLPathNodeStore) {
        if (self.mStoreTask==nil) {
            NSString *path=[[NSBundle mainBundle] pathForResource:@"storetask" ofType:@"plist"];
            self.mStoreTask=[NSArray arrayWithContentsOfFile:path];
        }
       taskArray=self.mStoreTask;
    }else if (nodeType==ZLPathNodeHospital) {
        if (self.mHospitalTask==nil) {
            NSString *path=[[NSBundle mainBundle] pathForResource:@"hospitaltask" ofType:@"plist"];
            self.mHospitalTask=[NSArray arrayWithContentsOfFile:path];
        }
       taskArray=self.mHospitalTask;
    }
    if (taskArray&&[taskArray count]) {
        return [taskArray objectAtIndex:arc4random()%([taskArray count])];
    }
    return nil;
}

-(void)createOptionViewWithTask:(NSString *)taskName atPosition:(CGPoint)position
{
    HSStretchableButton *button=[[HSStretchableButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"scroll.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapOptionButton:) forControlEvents:UIControlEventTouchUpInside];
    button.center=position;
    [self.view addSubview:button];
    [button stretchImage];
    [button setTitle:taskName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
}

-(void)showNodeTaskOPtionsView:(ZLPathNodeType)nodeType atPosition:(CGPoint)position
{
    if (bShowAlertView) {
        return;
    }
   NSString* taskName=[self createNodeTaskForType:nodeType];
    if (taskName!=nil) {
        bShowAlertView=YES;
        ZLAlertView *alertView=[[ZLAlertView alloc] initWithTitle:NSLocalizedString(@"New Task", nil) message:NSLocalizedString(taskName, nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) confirmButtonTitles:NSLocalizedString(@"Accept", nil)];
        alertView.tag=TAP_BUILDING_ALERTVIEW_TAG;
        [alertView show];
        //[self createOptionViewWithTask:taskName atPosition:position];
    }
}

-(void)onTapOptionButton:(UIButton *)button
{
    [button removeFromSuperview];
    button=nil;
    if (self.mPortraitScene) {
        [self.mPortraitScene startTask];
        //[NSNotificationCenter defaultCenter];
    }
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveTapBuildingNotification:) name:TAP_BUILDING_NOTIFICATION object:nil];
}

-(void)onReceiveTapBuildingNotification:(NSNotification *)notification
{
    NSDictionary *notiData=[notification userInfo];
    ZLPathNodeType nodeType=[[notiData objectForKey:@"node"] intValue];
    if (nodeType==ZLPathNodeGameCenter) {
        [self onTapGameCenter];
    }else{
        CGPoint targetPosition=CGPointFromString([notiData objectForKey:@"position"]);
        [self showNodeTaskOPtionsView:nodeType atPosition:targetPosition];
    }
}

#pragma mark - ZLAlertViewDelegate
- (void)alertView:(ZLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    bShowAlertView=NO;
    if (alertView.tag==GAMECENTER_ALERTVIEW_TAG) {
         [self resetGameCenterStatus];
    }else if(alertView.tag==TAP_BUILDING_ALERTVIEW_TAG){
        if (buttonIndex==[alertView cancelButtonIndex]) {
            if (self.mPortraitScene) {
                [self.mPortraitScene cancelledTask];
                //[NSNotificationCenter defaultCenter];
            }
        }else{
            if (self.mPortraitScene) {
                [self.mPortraitScene startTask];
                //[NSNotificationCenter defaultCenter];
            }
        }
    }
}

@end
