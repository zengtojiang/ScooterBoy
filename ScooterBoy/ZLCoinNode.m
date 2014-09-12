//
//  ZLCoinNode.m
//  SpriteKit
//
//  Created by libs on 14-3-29.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "ZLCoinNode.h"

@implementation ZLCoinNode
+(ZLCoinNode *)createCoinWithType:(SKTextureType)textureType
{
    ZLCoinNode *coinSprite=[[ZLCoinNode alloc] initWithTexture:[SKSharedAtles textureWithType:textureType]];
    coinSprite.coinValue=1;
    coinSprite.movespeed=arc4random()%3+2;
//    if (textureType==SKTextureTypeBean) {
//        coinSprite.coinValue=2;
//    }else{
//        coinSprite.coinValue=1;
//    }
    coinSprite.anchorPoint=CGPointMake(0.5, 0.5);
    coinSprite.zPosition=1;
    coinSprite.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:(coinSprite.size.width*0.9f)/2];
    //coinSprite.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:CGSizeApplyAffineTransform(coinSprite.size, CGAffineTransformMakeScale(0.8, 0.8))];
    coinSprite.physicsBody.categoryBitMask=SKRoleCategoryCoin;
    //bombSprite.physicsBody.collisionBitMask = SKRoleCategoryHero;
    coinSprite.physicsBody.contactTestBitMask=SKRoleCategoryHero;
    //coinSprite.physicsBody.dynamic=NO;
    coinSprite.physicsBody.angularDamping=1.0;
    coinSprite.physicsBody.mass=1;
    coinSprite.physicsBody.friction=0.0;
    coinSprite.physicsBody.restitution=0.0;
    coinSprite.physicsBody.linearDamping=0.0;
   // [coinSprite runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1.0]]];

    return coinSprite;
}

@end
