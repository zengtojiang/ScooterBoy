//
//  ZLHistoryManager.h
//  ScooterBoy
//
//  Created by libs on 14-3-16.
//  Copyright (c) 2014年 icow. All rights reserved.
//
/**
 历史记录保持器
 */
#import <Foundation/Foundation.h>

@interface ZLHistoryManager : NSObject

#pragma mark - 积分
//get最新分数
+(NSUInteger)getLastScore;

//set最新分数
+(void)setLastScore:(NSUInteger)score;

+(void)addNewScore:(int)score;

#pragma mark - 金币
//总金币
+(NSUInteger)getLastGold;

+(void)setLastGold:(NSUInteger)gold;
//添加新金币
+(void)addNewGold:(int)gold;
//最佳记录
+(int)getMaxGold;

#pragma mark -

//音效开关是否打开
+(BOOL)voiceOpened;

//设置音效开关
+(void)setVoiceOpened:(BOOL)open;

//背景音乐开关是否打开
+(BOOL)musicOpened;

//设置背景音乐开关
+(void)setMusicOpened:(BOOL)open;

//是否是第一次进入应用
+(BOOL)isFirstLaunch;

//设置为不是第一次进入应用
+(void)setFirstLaunch;
@end
