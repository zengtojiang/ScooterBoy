//
//  ZLCoinNode.h
//  SpriteKit
//
//  Created by libs on 14-3-29.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//
/**
  金币
 */
#import <SpriteKit/SpriteKit.h>
#import "SKSharedAtles.h"

@interface ZLCoinNode : SKSpriteNode

+(ZLCoinNode *)createCoinWithType:(SKTextureType)textureType;

@property(nonatomic,assign)int  coinValue;//金币价值
@property(nonatomic,assign)int  movespeed;//
@end
