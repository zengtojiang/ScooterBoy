//
//  ZLBuildingNode.h
//  ScooterBoy
//
//  Created by jiangll on 14-3-24.
//  Copyright (c) 2014年 icow. All rights reserved.
//
/**
 家、学校、商店、医院等建筑
 */
#import <SpriteKit/SpriteKit.h>
#import "ZLPathNode.h"

#define ZL_BUILDING_WIDTH   70


@interface ZLBuildingNode : SKSpriteNode

+(ZLBuildingNode *)createWithNodeType:(ZLPathNodeType)nodetype;

@property(nonatomic,assign)ZLPathNodeType nodetype;
@end
