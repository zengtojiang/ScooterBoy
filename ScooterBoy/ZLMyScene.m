//
//  ZLMyScene.m
//  ScooterBoy
//
//  Created by libs on 14-3-15.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLMyScene.h"
#import "ZLHistoryManager.h"
#import <GameKit/GameKit.h>

#define ZL_MAP_TOP_MARGIN       32//48//40
#define ZL_MAP_LEFT_MARGIN      32//48//60
#define ZL_LOAD_WIDTH           32//14

#define ZL_HERO_WIDTH           ZL_LOAD_WIDTH

#define ZL_HERO_SPEED           (120)

@implementation ZLMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self initPhysicsWorld];
        [self initBackgroundAndLoads];
        [self initPositions];
        [self initEnvironment];
        [self initPathNodes];//初始化路径节点
        [self initScooterBoy];
        [self initGameCenter];
        
        /*
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Portrait!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
         */
    }
    return self;
}

-(void)initPhysicsWorld
{
    self.physicsWorld.gravity=CGVectorMake(0, 0);
    //self.physicsWorld.contactDelegate=self;
}

-(void)initPathNodes
{
    CGPoint locationPosition;
    //家
    ZLPathNode *homeNode=[ZLPathNode new];
    homeNode.nodeType=ZLPathNodeHome;
    locationPosition=mHomePosition;
    locationPosition.x +=ZL_BUILDING_WIDTH/2;
    locationPosition.y -=ZL_HERO_WIDTH/2;
    homeNode.nodeLocation=locationPosition;
    
    //学校
    ZLPathNode *schoolNode=[ZLPathNode new];
    schoolNode.nodeType=ZLPathNodeSchool;
    locationPosition=mSchoolPosition;
    locationPosition.x +=ZL_BUILDING_WIDTH+ZL_HERO_WIDTH/2;
    locationPosition.y +=ZL_BUILDING_WIDTH/2;
    schoolNode.nodeLocation=locationPosition;
    
    //商店
    ZLPathNode *storeNode=[ZLPathNode new];
    storeNode.nodeType=ZLPathNodeStore;
    locationPosition=mStorePosition;
    locationPosition.x +=ZL_BUILDING_WIDTH/2;
    locationPosition.y +=ZL_HERO_WIDTH/2+ZL_BUILDING_WIDTH;
    storeNode.nodeLocation=locationPosition;
    
    //医院
    ZLPathNode *hospitalNode=[ZLPathNode new];
    hospitalNode.nodeType=ZLPathNodeHospital;
    locationPosition=mHospitalPosition;
    locationPosition.x -=ZL_HERO_WIDTH/2;
    locationPosition.y +=ZL_BUILDING_WIDTH/2;
    hospitalNode.nodeLocation=locationPosition;
    
    //左上
    ZLPathNode *leftTopNode=[ZLPathNode new];
    leftTopNode.nodeType=ZLPathNodeLeftTop;
    locationPosition.x =hospitalNode.nodeLocation.x;
    locationPosition.y =homeNode.nodeLocation.y;
    leftTopNode.nodeLocation=locationPosition;
    
    //左下
    ZLPathNode *leftBottomNode=[ZLPathNode new];
    leftBottomNode.nodeType=ZLPathNodeLeftBottom;
    locationPosition.x =hospitalNode.nodeLocation.x;
    locationPosition.y =ZL_MAP_TOP_MARGIN+ZL_LOAD_WIDTH/2;
    leftBottomNode.nodeLocation=locationPosition;
    
    //右下
    ZLPathNode *rightBottomNode=[ZLPathNode new];
    rightBottomNode.nodeType=ZLPathNodeRightBottom;
    locationPosition.x =schoolNode.nodeLocation.x;
    locationPosition.y =leftBottomNode.nodeLocation.y;
    rightBottomNode.nodeLocation=locationPosition;
    
    //右上
    ZLPathNode *rightTopNode=[ZLPathNode new];
    rightTopNode.nodeType=ZLPathNodeRightTop;
    locationPosition.x =schoolNode.nodeLocation.x;
    locationPosition.y =homeNode.nodeLocation.y;
    rightTopNode.nodeLocation=locationPosition;
    
   //创建链表
    mPathNodeLinkedList=[[NSMutableDictionary alloc] initWithCapacity:8];
    [mPathNodeLinkedList setObject:homeNode forKey:[NSNumber numberWithInt:homeNode.nodeType]];
    [mPathNodeLinkedList setObject:leftTopNode forKey:[NSNumber numberWithInt:leftTopNode.nodeType]];
    [mPathNodeLinkedList setObject:hospitalNode forKey:[NSNumber numberWithInt:hospitalNode.nodeType]];
    [mPathNodeLinkedList setObject:leftBottomNode forKey:[NSNumber numberWithInt:leftBottomNode.nodeType]];
    [mPathNodeLinkedList setObject:rightBottomNode forKey:[NSNumber numberWithInt:rightBottomNode.nodeType]];
    [mPathNodeLinkedList setObject:schoolNode forKey:[NSNumber numberWithInt:schoolNode.nodeType]];
    [mPathNodeLinkedList setObject:rightTopNode forKey:[NSNumber numberWithInt:rightTopNode.nodeType]];
    [mPathNodeLinkedList setObject:storeNode forKey:[NSNumber numberWithInt:storeNode.nodeType]];
    //前后节点设置
    homeNode.foreNode=storeNode;
    homeNode.nextNode=leftTopNode;
    
    leftTopNode.foreNode=homeNode;
    leftTopNode.nextNode=hospitalNode;
    
    hospitalNode.foreNode=leftTopNode;
    hospitalNode.nextNode=leftBottomNode;
    
    leftBottomNode.foreNode=hospitalNode;
    leftBottomNode.nextNode=rightBottomNode;
    
    rightBottomNode.foreNode=leftBottomNode;
    rightBottomNode.nextNode=schoolNode;
    
    schoolNode.foreNode=rightBottomNode;
    schoolNode.nextNode=rightTopNode;
    
    rightTopNode.foreNode=schoolNode;
    rightTopNode.nextNode=storeNode;
    
    storeNode.foreNode=rightTopNode;
    storeNode.nextNode=homeNode;
    
    homeNode.toNextLength=[self distanceFromPoint:homeNode.nodeLocation toPoint:homeNode.nextNode.nodeLocation];
    leftTopNode.toNextLength=[self distanceFromPoint:leftTopNode.nodeLocation toPoint:leftTopNode.nextNode.nodeLocation];
    hospitalNode.toNextLength=[self distanceFromPoint:hospitalNode.nodeLocation toPoint:hospitalNode.nextNode.nodeLocation];
    leftBottomNode.toNextLength=[self distanceFromPoint:leftBottomNode.nodeLocation toPoint:leftBottomNode.nextNode.nodeLocation];
    rightBottomNode.toNextLength=[self distanceFromPoint:rightBottomNode.nodeLocation toPoint:rightBottomNode.nextNode.nodeLocation];
    schoolNode.toNextLength=[self distanceFromPoint:schoolNode.nodeLocation toPoint:schoolNode.nextNode.nodeLocation];
    rightTopNode.toNextLength=[self distanceFromPoint:rightTopNode.nodeLocation toPoint:rightTopNode.nextNode.nodeLocation];
    storeNode.toNextLength=[self distanceFromPoint:storeNode.nodeLocation toPoint:storeNode.nextNode.nodeLocation];
   
    mPathTotalLength=homeNode.toNextLength+leftTopNode.toNextLength+ hospitalNode.toNextLength+leftBottomNode.toNextLength+rightBottomNode.toNextLength+schoolNode.toNextLength+rightTopNode.toNextLength+storeNode.toNextLength;
    ZLTRACE(@"finalPathLinkedList:%@",mPathNodeLinkedList);
    
}

-(void)initBackgroundAndLoads
{
    //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    SKSpriteNode *spriteBG = [SKSpriteNode spriteNodeWithImageNamed:iPhone5?@"portraitbg568.png":@"portraitbg.png"];
    spriteBG.zPosition=0;
    spriteBG.anchorPoint=CGPointMake(0, 0);
    spriteBG.position = CGPointZero;//CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    [self addChild:spriteBG];
    
    //创建路径
    //CGMutablePathRef path=CGPathCreateMutable();
    CGAffineTransform *transform=NULL;
    CGRect rect=CGRectMake(ZL_MAP_LEFT_MARGIN+ZL_LOAD_WIDTH/2, ZL_MAP_TOP_MARGIN+ZL_LOAD_WIDTH/2, self.size.width-2*(ZL_MAP_LEFT_MARGIN)-ZL_LOAD_WIDTH, self.size.height-2*(ZL_MAP_TOP_MARGIN)-ZL_LOAD_WIDTH-20-ZL_BUILDING_WIDTH);
    //CGRect rect=CGRectMake(ZL_MAP_LEFT_MARGIN, ZL_MAP_TOP_MARGIN, self.size.width-2*(ZL_MAP_LEFT_MARGIN), self.size.height-2*(ZL_MAP_TOP_MARGIN)-20-ZL_BUILDING_WIDTH);
    mLoadFrame=rect;
    /*
    // start at origin
    CGPathMoveToPoint (path, transform, CGRectGetMinX(rect), CGRectGetMinY(rect));
    // add bottom edge
    CGPathAddLineToPoint (path, transform, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    // add right edge
    CGPathAddLineToPoint (path, transform, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    // add top edge
    CGPathAddLineToPoint (path, transform, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    // add left edge and close
    CGPathCloseSubpath (path);
     */
   CGPathRef path= CGPathCreateWithRoundedRect(rect,4, 4,transform);
    mLoadPath=path;
    /*
    SKShapeNode *loadShape=[SKShapeNode node];
    loadShape.path=path;
    loadShape.zPosition=0;
    loadShape.lineWidth=ZL_LOAD_WIDTH;
    loadShape.fillColor=[SKColor clearColor];
    loadShape.strokeColor=[SKColor yellowColor];
    [self addChild:loadShape];
     */
}

-(void)initPositions
{
    /*
    mHomePosition=CGPointMake(ZL_MAP_LEFT_MARGIN+ZL_BUILDING_WIDTH/2+ZL_LOAD_WIDTH, self.size.height-ZL_MAP_TOP_MARGIN-ZL_BUILDING_WIDTH/2+20);
    mSchoolPosition=CGPointMake(self.size.width-ZL_MAP_LEFT_MARGIN-ZL_BUILDING_WIDTH/2-ZL_LOAD_WIDTH, ZL_BUILDING_WIDTH/2+ZL_MAP_TOP_MARGIN+ZL_LOAD_WIDTH+20);
    mStorePosition=CGPointMake(self.size.width-ZL_MAP_LEFT_MARGIN-ZL_BUILDING_WIDTH/2-ZL_LOAD_WIDTH, self.size.height-ZL_MAP_TOP_MARGIN-ZL_BUILDING_WIDTH/2+20);
    mHospitalPosition=CGPointMake(ZL_MAP_LEFT_MARGIN+ZL_BUILDING_WIDTH/2+ZL_LOAD_WIDTH, ZL_BUILDING_WIDTH/2+ZL_MAP_TOP_MARGIN+ZL_LOAD_WIDTH+20);
    */
    mHomePosition=CGPointMake((self.size.width-ZL_BUILDING_WIDTH)/2, self.size.height-ZL_MAP_TOP_MARGIN-ZL_BUILDING_WIDTH-20);
    mSchoolPosition=CGPointMake(self.size.width-ZL_MAP_LEFT_MARGIN-ZL_BUILDING_WIDTH-ZL_LOAD_WIDTH, ZL_MAP_TOP_MARGIN+ZL_LOAD_WIDTH);
    mStorePosition=CGPointMake(self.size.width-ZL_MAP_LEFT_MARGIN-ZL_BUILDING_WIDTH-ZL_LOAD_WIDTH, self.size.height-ZL_MAP_TOP_MARGIN-ZL_BUILDING_WIDTH*2-20-ZL_LOAD_WIDTH);
    mHospitalPosition=CGPointMake(ZL_MAP_LEFT_MARGIN+ZL_LOAD_WIDTH, ZL_MAP_TOP_MARGIN+ZL_LOAD_WIDTH);
    mBoyPosition=ZLPathNodeHome;//男孩初始在家的位置
    //mBoyPosition=CGPointMake(ZL_MAP_LEFT_MARGIN+30, self.size.height-ZL_MAP_TOP_MARGIN-60);
}

//添加环境，如家、学校等建筑
-(void)initEnvironment
{
    //家
    mHome=[ZLBuildingNode createWithNodeType:ZLPathNodeHome];
    mHome.zPosition=1;
    mHome.position=mHomePosition;
    [self addChild:mHome];
    
    //学校
    mSchool=[ZLBuildingNode createWithNodeType:ZLPathNodeSchool];
    mSchool.zPosition=1;
    mSchool.position=mSchoolPosition;
    [self addChild:mSchool];
    
    //商店
    mStore=[ZLBuildingNode createWithNodeType:ZLPathNodeStore];
    mStore.zPosition=1;
    mStore.position=mStorePosition;
    [self addChild:mStore];
    
    //医院
    mHospital=[ZLBuildingNode createWithNodeType:ZLPathNodeHospital];
    mHospital.zPosition=1;
    mHospital.position=mHospitalPosition;
    [self addChild:mHospital];
}

-(void)initScooterBoy
{
    //mBoyPosition=mHome.targetPosition;
    mScooterBoy=[SKSpriteNode spriteNodeWithImageNamed:@"playerthumb.png"];//[SKSpriteNode spriteNodeWithColor:[SKColor purpleColor] size:CGSizeMake(ZL_HERO_WIDTH, ZL_HERO_WIDTH)];
    mScooterBoy.zPosition=1;
    mScooterBoy.anchorPoint=CGPointMake(0.5, 0.5);
    mScooterBoy.position=((ZLPathNode *)[mPathNodeLinkedList objectForKey:[NSNumber numberWithInt:mBoyPosition]]).nodeLocation;
    [self addChild:mScooterBoy];
    //[self playScooterAction];
}

-(void)initGameCenter
{
    gameNode=[SKSpriteNode spriteNodeWithImageNamed:@"gamecenter.png"];
    gameNode.zPosition=4;
    gameNode.anchorPoint=CGPointMake(0.5, 0.5);
    gameNode.size=CGSizeMake(50, 50);
    gameNode.position=CGPointMake(CGRectGetMaxX(self.frame)-50/2-10, CGRectGetMaxY(self.frame)-50/2-10-20);
    [self addChild:gameNode];
    
    achieveAudioAction=[SKAction playSoundFileNamed:@"acheivement.mp3" waitForCompletion:NO];
}

-(void)loadAchievements
{
    if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
        [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
            self.mReachedAchieve=achievements;
            ZLTRACE(@"%@",self.mReachedAchieve);
        }];
    }
}
#pragma mark - actions

-(void)playScooterAction
{
    if (![mScooterBoy actionForKey:@"slideAction"]) {
        float alta=3;
         SKAction *circleAction=[SKAction sequence:@[
        [SKAction moveToX:CGRectGetMinX(mLoadFrame) duration:0.5*alta],
        [SKAction moveToY:CGRectGetMinY(mLoadFrame) duration:1.5*alta],
        [SKAction moveToX:CGRectGetMaxX(mLoadFrame) duration:1*alta],
        [SKAction moveToY:CGRectGetMaxY(mLoadFrame) duration:1.5*alta],
        [SKAction moveToX:CGRectGetMidX(mLoadFrame) duration:0.5*alta]]];
        [mScooterBoy runAction:[SKAction repeatActionForever:circleAction] withKey:@"slideAction"];
        /*
        [mScooterBoy runAction:[SKAction repeatActionForever:[SKAction runBlock:^{
            CGPoint curLocation=mScooterBoy.position;
            CGAffineTransform transform=CGAffineTransformMakeTranslation(-curLocation.x,-curLocation.y);
            CGPathRef path=CGPathCreateCopyByTransformingPath(mLoadPath,&transform);
            [mScooterBoy runAction:[SKAction followPath:path duration:5]];
            
        }]] withKey:@"slideAction"];
        */
        //[mScooterBoy runAction:[SKAction repeatActionForever:[SKAction followPath:path duration:4]] withKey:@"slideAction"];
    }

}

-(void)onReachPosition:(CGPoint)position
{
    
}

-(void)onReachBuilding:(ZLBuildingNode *)building
{
    
}

-(float)distanceFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2
{
    return sqrtf(powf((point1.x-point2.x),2)+powf(point1.y-point2.y, 2));
}

-(void)moveFromNodeA:(ZLPathNodeType)curNodeType toNodeB:(ZLPathNodeType)tarNodeType
{
    //先计算顺时针距离
    float antiClockWiseDistance=0;
    NSMutableArray *actionArray=[NSMutableArray array];
    ZLPathNode *curNode=[mPathNodeLinkedList objectForKey:[NSNumber numberWithInt:curNodeType]];
    while (curNode.nodeType!=tarNodeType) {
        antiClockWiseDistance +=curNode.toNextLength;
        [actionArray addObject:[SKAction moveTo:curNode.nextNode.nodeLocation duration:curNode.toNextLength/ZL_HERO_SPEED]];
        curNode=curNode.nextNode;
    }
    if (antiClockWiseDistance>mPathTotalLength/2) {
        [actionArray removeAllObjects];
        curNode=[mPathNodeLinkedList objectForKey:[NSNumber numberWithInt:curNodeType]];
        while (curNode.nodeType!=tarNodeType) {
            //curNode=curNode.foreNode;
            //antiClockWiseDistance +=curNode.toNextLength;
            [actionArray addObject:[SKAction moveTo:curNode.foreNode.nodeLocation duration:curNode.foreNode.toNextLength/ZL_HERO_SPEED]];
            curNode=curNode.foreNode;
        }
    }
    [actionArray addObject:[SKAction runBlock:^{
        [ZLHistoryManager addNewScore:ZL_SCORE_PER_TASK];
        [self detectNewScoreRecord];
        [self runAction:achieveAudioAction];
        //mBoyPosition=tarNodeType;
    }]];
    [mScooterBoy runAction:[SKAction sequence:actionArray] withKey:@"slideAction"];
    
}

-(void)startTask;
{
    [self moveFromNodeA:mBoyPosition toNodeB:mBoyTargetPosition];
    mBoyPosition=mBoyTargetPosition;
    [self loadAchievements];
}

-(void)cancelledTask
{
    mBoyTargetPosition=mBoyPosition;
}

-(void)detectNewScoreRecord
{
    if (self.mAcheiveArray==nil) {
        self.mAcheiveArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"acheivelist" ofType:@"plist"]];
    }
    NSUInteger curScore=[ZLHistoryManager getLastScore];
    if (curScore>0) {
        if ([[GKLocalPlayer localPlayer] isAuthenticated]){
            [self.mAcheiveArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ZLTRACE(@"index:%d obj:%@",idx,obj);
                NSDictionary *dicData=(NSDictionary *)obj;
                int  acheiveValue=[[dicData objectForKey:@"stone"] intValue];
                //NSString *acheivmentDesc=[dicData objectForKey:@"acheive"];
                if (curScore>=acheiveValue) {
                    NSString *achievementId=[NSString stringWithFormat:ZL_NEW_ACHEIVEMENT_IDENTIFIER,idx];
                    BOOL hasAchieved=NO;
                    if (idx!=0) {
                        if (self.mReachedAchieve&&[self.mReachedAchieve count]) {
                            for (int i=0; i<[self.mReachedAchieve count]; i++) {
                                GKAchievement *acheiveItem=[self.mReachedAchieve objectAtIndex:i];
                                if (acheiveItem.isCompleted&&[acheiveItem.identifier isEqualToString:achievementId]) {
                                    hasAchieved=YES;
                                    break;
                                }
                            }
                        }
                    }
                    if (hasAchieved) {
                        achievementId=[NSString stringWithFormat:ZL_NEW_ACHEIVEMENT_IDENTIFIER,0];
                    }
                    ZLTRACE(@"curScore:%d acheiveScore:%d",curScore,acheiveValue);
                   
                    GKAchievement *newAcheivement=[[GKAchievement alloc] initWithIdentifier:achievementId];
                    newAcheivement.percentComplete=100;
                    newAcheivement.showsCompletionBanner=YES;
                    [GKAchievement reportAchievements:[NSArray arrayWithObject:newAcheivement] withCompletionHandler:^(NSError *error) {
                        ZLTRACE(@"occur error:%@",error);
                    }];
                    [self loadAchievements];
                    *stop=YES;
                }
            }];
        }
    }
}

-(void)onTapBuilding:(ZLBuildingNode *)building
{
    //if (![mScooterBoy actionForKey:@"slideAction"])
     if ((![mScooterBoy actionForKey:@"slideAction"])||(mBoyPosition!=mBoyTargetPosition))
    {
        ZLPathNodeType curLocation=mBoyPosition;
        ZLPathNodeType tarLocation=building.nodetype;
        if (curLocation==tarLocation) {
            ZLTRACE(@"current has been the location, dont need to move");
            return;
        }
        mBoyTargetPosition=tarLocation;
        ZLPathNode *curNode=[mPathNodeLinkedList objectForKey:[NSNumber numberWithInt:mBoyTargetPosition]];
        [[NSNotificationCenter defaultCenter] postNotificationName:TAP_BUILDING_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mBoyTargetPosition],@"node",NSStringFromCGPoint([self convertPointToView:curNode.nodeLocation]),@"position", nil]];
        //mBoyPosition=tarLocation;
        //[self moveFromNodeA:curLocation toNodeB:tarLocation];
        /*
        //if (building==mHospital) {
            float distance=0;
            //CGMutablePathRef path=CGPathCreateMutable();
            CGRect loadFrame=CGPathGetBoundingBox(mLoadPath);
            ZLTRACE(@"loadFrame:%@",NSStringFromCGRect(loadFrame));
            //CGAffineTransform transform=CGAffineTransformMakeTranslation(-loadFrame.origin.x-curLocation.x,-loadFrame.origin.y-curLocation.y);
            CGAffineTransform transform=CGAffineTransformMakeTranslation(-curLocation.x,-curLocation.y);
            CGPoint point0=curLocation;
            CGPoint point1=point0;
            point1.x=mLoadFrame.origin.x;
            ZLTRACE(@"curLocation:%@ load origin:%f point1:%@",NSStringFromCGPoint(curLocation),mLoadFrame.origin.x,NSStringFromCGPoint(point1));
            CGPoint point2=point1;
            point2.y=tarLocation.y;
            
            //CGPathMoveToPoint(path,transform,point0.x,point0.y);
            //CGPathAddLineToPoint(path, transform, point1.x, point1.y);
            distance +=fabsf(point1.x-point0.x);
            //CGPathAddLineToPoint(path, transform, point2.x, point2.y);
            distance +=point2.y-point1.y;
            
            CGPathRef path=CGPathCreateCopyByTransformingPath(mLoadPath,&transform);
         
            CGPoint points[]={point0,point1};//{point0,point1,point2};
            points[0]=curLocation;
            CGPathAddLines(path, transform, points, 2);
             
            [mScooterBoy runAction:[SKAction sequence:@[[SKAction followPath:path duration:2],[SKAction runBlock:^{
                [self onReachBuilding:building];
            }]]] withKey:@"slideAction"];
             //
            [mScooterBoy runAction:[SKAction sequence:@[[SKAction followPath:path duration:2],[SKAction runBlock:^{
                [self onReachBuilding:building];
            }]]] withKey:@"slideAction"];
            //SKAction *action=[SKAction sequence:@[[SKAction followPath:path duration:2],]];
            //[mScooterBoy runAction:<#(SKAction *)#>];
         */
    }
     
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if(CGRectContainsPoint(mHome.frame, location)){
            [self onTapBuilding:mHome];
        }else if(CGRectContainsPoint(mSchool.frame, location)){
            [self onTapBuilding:mSchool];
        }else if(CGRectContainsPoint(mStore.frame, location)){
            [self onTapBuilding:mStore];
        }else if(CGRectContainsPoint(mHospital.frame, location)){
            [self onTapBuilding:mHospital];
        }else if(CGRectContainsPoint(gameNode.frame, location)){
            [[NSNotificationCenter defaultCenter] postNotificationName:TAP_BUILDING_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ZLPathNodeGameCenter],@"node",nil]];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
