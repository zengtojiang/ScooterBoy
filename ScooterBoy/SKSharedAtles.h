//
//  SKSharedAtles.h
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, SKTextureType) {
    SKTextureTypeBackground = 1,
    SKTextureTypeBackLayer1 = 2,
    SKTextureTypeBackLayer2 = 3,
    SKTextureTypeHero =4,
    SKTextureTypeHeroUp =5,
    SKTextureTypeObstacle=6,//障碍
    SKTextureTypeCoin=7,//金币
};

typedef NS_ENUM(int, ZLSTARLEVEL) {
    ZLSTARLEVELOne = 1,
    ZLSTARLEVELTwo = 2,
    ZLSTARLEVELThree = 3,
    ZLSTARLEVELFour =4,
};

@interface SKSharedAtles : SKTextureAtlas

+ (SKTexture *)textureWithType:(SKTextureType)type;

+ (SKAction *)playerAction;

+ (SKAction *)coinRotateAction;

+ (SKTexture *)starTextureWithLevel:(ZLSTARLEVEL)starLevel;

@end
