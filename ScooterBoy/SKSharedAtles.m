//
//  SKSharedAtles.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKSharedAtles.h"

static SKSharedAtles *_shared = nil;

@implementation SKSharedAtles


+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = (SKSharedAtles *)[SKSharedAtles atlasNamed:@"player"];
    });
    return _shared;
}


+ (SKTexture *)textureWithType:(SKTextureType)type{
    
    switch (type) {
        case SKTextureTypeBackground:
        {
            UIImage *imageTile = [UIImage imageNamed:@"ground.png"];
            CGRect  textureRect = CGRectMake(0, 0, imageTile.size.width, imageTile.size.height);
            UIGraphicsBeginImageContext(CGSizeMake(568, imageTile.size.height));//[[UIScreen mainScreen] currentMode].size
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextRotateCTM(context, M_PI); //先旋转180度，是按照原先顺时针方向旋转的。这个时候会发现位置偏移了
            CGContextScaleCTM(context, -1, 1); //再水平旋转一下
            CGContextTranslateCTM(context,0, -imageTile.size.height);
            CGContextDrawTiledImage(context, textureRect, imageTile.CGImage);
            UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return [SKTexture textureWithCGImage:retImage.CGImage];
        }
            break;
        case SKTextureTypeBackLayer1:
            return [SKTexture textureWithImageNamed:@"bg_layer1.png"];
            // return [[[self class] shared] textureNamed:@"bg_layer1"];
            break;
        case SKTextureTypeBackLayer2:
            return [SKTexture textureWithImageNamed:@"bg_layer2.png"];
            //return [[[self class] shared] textureNamed:@"bg_layer2"];
            break;
        case SKTextureTypeHero:
            return [[[self class] shared] textureNamed:@"Playern3.png"];
            break;
        case SKTextureTypeHeroUp:
            return [[[self class] shared] textureNamed:@"Playern2.png"];
            break;
        case SKTextureTypeObstacle:
        {
            //int wallCount= (arc4random() % 6);
            int randNum=(arc4random()%5);
            //return [SKTexture textureWithImageNamed:@"wall_tile.png"];
            return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"roadobs%d.png",randNum==0?0:1]];
            //return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"roadobs%d.png",randNum]];
        }
            break;
        case SKTextureTypeCoin:
            return [[[self class] shared] textureNamed:@"Coins_00.png"];
            return [SKTexture textureWithImageNamed:@"coin.png"];
            //return [[[self class] shared] textureNamed:@"pause.png"];
            break;
        default:
            break;
    }
    return nil;
}

+ (SKTexture *)starTextureWithLevel:(ZLSTARLEVEL)starLevel;
{
    switch (starLevel) {
        case ZLSTARLEVELOne:
             return [[[self class] shared] textureNamed:@"star1.png"];
            break;
        case ZLSTARLEVELTwo:
            return [[[self class] shared] textureNamed:@"star2.png"];
            break;
        case ZLSTARLEVELThree:
            return [[[self class] shared] textureNamed:@"star3.png"];
            break;
        case ZLSTARLEVELFour:
            return [[[self class] shared] textureNamed:@"star4.png"];
            break;
        default:
            break;
    }
    return nil;
}

+ (SKTexture *)playerTextureWithIndex:(int)index{
    //return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"player1-n%d.png",index]];
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"Player%d.png",index]];
}

+ (SKTexture *)coinTextureWithIndex:(int)index{
    //ZLTRACE(@"coinTextName:%@",[NSString stringWithFormat:@"Coins_%02d.png",index]);
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"Coins_%02d.png",index]];
}

//+ (SKAction *)playerAction
//{
//    //    NSMutableArray *textures = [[NSMutableArray alloc]init];
//    //
//    //    for (int i= 1; i<=3; i++) {
//    //        SKTexture *texture = [[self class] playerTextureWithIndex:i];
//    //
//    //        [textures addObject:texture];
//    //    }
//    return [SKAction repeatActionForever:[SKAction sequence:@[[SKAction setTexture:[[self class] playerTextureWithIndex:1]],[SKAction waitForDuration:0.2],[SKAction setTexture:[[self class] playerTextureWithIndex:2]],[SKAction waitForDuration:0.1],[SKAction setTexture:[[self class] playerTextureWithIndex:3]],[SKAction waitForDuration:0.1]]]];
//    // return [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
//}


+ (SKAction *)playerAction
{
    NSMutableArray *textures = [[NSMutableArray alloc]init];
    
    for (int i= 1; i<=3; i++) {
        SKTexture *texture = [[self class] playerTextureWithIndex:i];
        
        [textures addObject:texture];
    }
    return [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
}

+ (SKAction *)coinRotateAction
{
    NSMutableArray *textures = [[NSMutableArray alloc]init];
    
    for (int i= 0; i<=5; i++) {
        SKTexture *texture = [[self class] coinTextureWithIndex:i];
        
        [textures addObject:texture];
    }
    return [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
}

@end
