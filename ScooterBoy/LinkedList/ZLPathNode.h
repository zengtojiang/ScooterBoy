//
//  ZLPathNode.h
//  ScooterBoy
//
//  Created by libs on 14-4-5.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLLinkedListNode.h"

typedef NS_ENUM(int, ZLPathNodeType) {
    ZLPathNodeHome=1,
    ZLPathNodeLeftTop=2,
    ZLPathNodeHospital=3,
    ZLPathNodeLeftBottom=4,
    ZLPathNodeRightBottom=5,
    ZLPathNodeSchool=6,
    ZLPathNodeRightTop=7,
    ZLPathNodeStore=8,
    ZLPathNodeGameCenter=9,
};


@interface ZLPathNode : NSObject

@property(nonatomic,assign)ZLPathNode *nextNode;
@property(nonatomic,assign)ZLPathNode *foreNode;
@property(nonatomic,assign)ZLPathNodeType nodeType;//节点标识
@property(nonatomic,assign)CGPoint        nodeLocation;//节点位置
@property(nonatomic,assign)float          toNextLength;//到下一节点的距离

@end
