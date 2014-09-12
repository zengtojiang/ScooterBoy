//
//  ZLPathNode.m
//  ScooterBoy
//
//  Created by libs on 14-4-5.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLPathNode.h"

@implementation ZLPathNode

-(NSString *)description
{
    return [NSString stringWithFormat:@"nodeType:%d,foreNodeType:%d,nextNodeType:%d,toNextNodeLength:%f",self.nodeType,self.foreNode.nodeType,self.nextNode.nodeType,self.toNextLength];
}
@end
