//
//  ZLHistoryManager.m
//  ScooterBoy
//
//  Created by libs on 14-3-16.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLHistoryManager.h"

@implementation ZLHistoryManager

#pragma mark - 积分
//get最新分数
+(NSUInteger)getLastScore;
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_LAST_SCORE"];
}

//set最新分数
+(void)setLastScore:(NSUInteger)score;
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"ZL_LAST_SCORE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)addNewScore:(int)score;
{
    NSUInteger lastscore=[ZLHistoryManager getLastScore];
    [ZLHistoryManager setLastScore:lastscore+score];
}

#pragma mark - 金币
//总金币
+(NSUInteger)getLastGold;
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_LAST_GOLD"];
}

+(void)setLastGold:(NSUInteger)gold;
{
    [[NSUserDefaults standardUserDefaults] setInteger:gold forKey:@"ZL_LAST_GOLD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//添加新金币
+(void)addNewGold:(int)gold;
{
    int lastRecord=[ZLHistoryManager getMaxGold];
    if (gold>lastRecord) {
        [[NSUserDefaults standardUserDefaults] setInteger:gold forKey:@"ZL_LAST_MAX_GOLD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSUInteger lastscore=[ZLHistoryManager getLastGold];
    [ZLHistoryManager setLastGold:lastscore+gold];
}

//最佳记录
+(int)getMaxGold;
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_LAST_MAX_GOLD"];
}

#pragma mark -


//音效开关是否打开
+(BOOL)voiceOpened
{
    int voiceState=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_VOICE_STATE"];
    if (voiceState==2) {
        return NO;
    }
    return YES;
}

//设置音效开关
+(void)setVoiceOpened:(BOOL)open;
{
    [[NSUserDefaults standardUserDefaults] setInteger:open?1:2 forKey:@"ZL_VOICE_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//背景音乐开关是否打开
+(BOOL)musicOpened;
{
    int voiceState=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_MUSIC_STATE"];
    if (voiceState==2) {
        return NO;
    }
    return YES;
}

//设置背景音乐开关
+(void)setMusicOpened:(BOOL)open;
{
    [[NSUserDefaults standardUserDefaults] setInteger:open?1:2 forKey:@"ZL_MUSIC_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//是否是第一次进入应用
+(BOOL)isFirstLaunch
{
    BOOL launched=[[NSUserDefaults standardUserDefaults] boolForKey:@"ZL_LAUNCHED"];
    if (!launched) {
        return YES;
    }
    return NO;
}

//设置为不是第一次进入应用
+(void)setFirstLaunch
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZL_LAUNCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
