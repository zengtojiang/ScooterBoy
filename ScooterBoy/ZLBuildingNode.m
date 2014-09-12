//
//  ZLBuildingNode.m
//  ScooterBoy
//
//  Created by jiangll on 14-3-24.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLBuildingNode.h"

@implementation ZLBuildingNode

+(ZLBuildingNode *)createWithNodeType:(ZLPathNodeType)nodetype
{
    NSString *buildingImageName=nil;
    if (nodetype==ZLPathNodeHome) {
        buildingImageName=@"home.png";
    }else if (nodetype==ZLPathNodeSchool) {
        buildingImageName=@"school.png";
    }else if (nodetype==ZLPathNodeStore) {
        buildingImageName=@"store.png";
    }else if (nodetype==ZLPathNodeHospital) {
        buildingImageName=@"hospital.png";
    }
    ZLBuildingNode* building=[ZLBuildingNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(ZL_BUILDING_WIDTH, ZL_BUILDING_WIDTH)];
    //building.zPosition=1;
    building.anchorPoint=CGPointMake(0, 0);
    building.nodetype=nodetype;
    
    
    SKSpriteNode *spriteNode=[SKSpriteNode spriteNodeWithImageNamed:buildingImageName];//[SKSpriteNode spriteNodeWithColor:[[self class] getNodeColor:type] size:CGSizeMake(40, 40)];
    //spriteNode.position=CGPointMake(building.size.width/2,spriteNode.size.height/2);
    spriteNode.position=CGPointMake((ZL_BUILDING_WIDTH-spriteNode.size.width)/2,0);
    //spriteNode.position=CGPointMake(ZL_BUILDING_WIDTH-spriteNode.size.width,0);
    spriteNode.anchorPoint=CGPointMake(0, 0);
    [building addChild:spriteNode];
    
    SKLabelNode *titleNode =[SKLabelNode labelNodeWithFontNamed:ZL_DEFAULT_FONT_NAME];// [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    titleNode.text = [[self class] getTitle:nodetype];
    titleNode.fontSize = ZL_SMALL_FONT_SIZE;
    titleNode.fontColor=ZL_HEADVIEW_TEXTCOLOR;
    //titleNode.anchorPoint=CGPointMake(0.5, 0.5);
    titleNode.position = CGPointMake(building.size.width/2,spriteNode.size.height+5);
    //titleNode.position = CGPointMake(0,spriteNode.size.height+5);
    [building addChild:titleNode];
    
    return building;
     
    //[self addChild:building];
}

+(NSString *)getTitle:(ZLPathNodeType)type
{
    switch (type) {
        case ZLPathNodeHome:
            return NSLocalizedString(@"Home", nil);
            break;
        case ZLPathNodeSchool:
            return NSLocalizedString(@"School",nil);
            break;
        case ZLPathNodeHospital:
            return NSLocalizedString(@"Hospital",nil);
            break;
        case ZLPathNodeStore:
            return NSLocalizedString(@"Store",nil);
            break;
        default:
            break;
    }
    return nil;
}

@end
