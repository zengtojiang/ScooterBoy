//
//  ZLMainScene.h
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
/**
 
 具有物理特性的物品的锚地必须在中心
 方法1：把两个body连接在一起，bodyA的密度小于1，bodyB的密度大于1，并且bodyA不能受重力影响，让bodyB带着bodyA运动，连接的锚点在bodyB的中心
 方法2：把两个body连接在一起，给bodyB施加作用力，带动bodyA运动，连接的锚点在bodyB上
 */
@interface ZLMainScene : SKScene<SKPhysicsContactDelegate>{
    
    BOOL       _bGameOver;
    BOOL       _bPlayVoice;
    
    //生命值
    int         _heroBlood;
    
    int         _birdVelocity;
    
    int         _obstacleGenerateTimer;
    int         _obstacleGenerateDuration;//障碍生成时间间隔
    int         _coinGenerateTimer;
    int         _coinGenerateDuration;//金币生成时间间隔
    
    //成就
    int         _curGold;//当前金币数
     int         _recordGold;//记录金币数
    SKLabelNode     *_goldLabel;
    SKLabelNode     *_recordGoldLabel;

    SKSpriteNode    *_playerHero;
    
    SKSpriteNode    *_backLayer1;
    int             _adjustmentBackgroundPosition;
    int             _adjustmentBackLayer1Position;
    int             _adjustmentBackLayer2Position;
    SKSpriteNode    *_backLayer2;
    SKSpriteNode    *_backLayer3;
    SKSpriteNode    *_backLayer4;
    SKSpriteNode     *_groundNode1;
    SKSpriteNode     *_groundNode2;
    
    //音效加载
    SKAction        *_playFlapAudio;//拍翅膀
    SKAction        *_playGoldAudio;//捡到金币
    SKAction        *_playHitAudio;//碰到墙壁
    //SKAction        *_playNewRecordAudio;//刷新记录
    
    //动作
    SKAction        *_HeroAction;
    SKAction        *_coinRotateAction;
}

@end
