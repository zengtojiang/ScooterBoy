//
//  ZLLinkedListNode.h
//  ScooterBoy
//
//  Created by libs on 14-4-5.
//  Copyright (c) 2014年 icow. All rights reserved.
//
/**
 链表节点
 */
#import <Foundation/Foundation.h>

@interface ZLLinkedListNode : NSObject

@property(nonatomic,assign)ZLLinkedListNode *nextNode;
@property(nonatomic,assign)ZLLinkedListNode *foreNode;

@end
