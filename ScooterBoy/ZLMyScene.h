//
//  ZLMyScene.h
//  ScooterBoy
//

//  Copyright (c) 2014年 icow. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ZLBuildingNode.h"
#import "ZLPathNode.h"

@interface ZLMyScene : SKScene
{
    CGPoint         mHomePosition;
    CGPoint         mSchoolPosition;
    CGPoint         mStorePosition;
    CGPoint         mHospitalPosition;
    
    CGRect          mLoadFrame;
    CGPathRef       mLoadPath;
    SKSpriteNode    *mScooterBoy;//滑板男
    ZLBuildingNode    *mHome;//家
    ZLBuildingNode    *mSchool;//学校
    ZLBuildingNode    *mStore;//商店
    ZLBuildingNode    *mHospital;//医院
    SKSpriteNode      *gameNode;
    
    SKAction          *achieveAudioAction;
    NSMutableDictionary  *mPathNodeLinkedList;//路径节点链表
    int                  mPathTotalLength;//路径总长度
    ZLPathNodeType       mBoyPosition;//当前男孩所在或将要去的目标节点
    ZLPathNodeType       mBoyTargetPosition;//
}

@property(nonatomic,retain)NSArray   *mAcheiveArray;
@property(nonatomic,retain)NSArray   *mReachedAchieve;
-(void)startTask;

-(void)cancelledTask;
@end
