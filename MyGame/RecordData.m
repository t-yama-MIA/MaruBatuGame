//
//  RecordData.m
//  MyGame
//
//  Created by トライアローズ開発 on 2016/03/04.
//  Copyright (c) 2016年 トライアローズ開発. All rights reserved.
//

#import "RecordData.h"

static NSString * const keyUserdefaultResult = @"result";
static NSString * const keyFirstWin  = @"first";
static NSString * const keySecondWin = @"second";
static NSString * const keyDraw      = @"draw";

@implementation RecordData

// 保存
+ (void)saveResult:(ResultType)result
{
    // 勝敗記録
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *record = [ud objectForKey:keyUserdefaultResult];
    NSMutableDictionary *r = nil;
    if (!record) {
        r = [@{} mutableCopy];
    } else {
        r = [record mutableCopy];
    }
    
    NSString *winKey;
    
    switch (result) {
        case ResultTypeFirst:
            winKey = keyFirstWin;
            break;
        case ResultTypeSecond:
            winKey = keySecondWin;
            break;
        case ResultTypeDraw:
            winKey = keyDraw;
            break;
    }
    
    NSNumber *numWinCount = r[winKey];
    if (!numWinCount) {
        numWinCount = @(0);
    }
    
    NSInteger winCount = [numWinCount integerValue];
    winCount++;
    numWinCount = @(winCount);
    
    r[winKey] = numWinCount;
    
    [ud setObject:r forKey:keyUserdefaultResult];
    [ud synchronize];
}

// 呼び出し
+ (NSInteger)loadResult:(ResultType)result
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *record = [ud objectForKey:keyUserdefaultResult];
    NSMutableDictionary *r = nil;
    if (!record) {
        r = [@{} mutableCopy];
    } else {
        r = [record mutableCopy];
    }
    
    NSString *winKey;
    switch (result) {
        case ResultTypeFirst:
            winKey = keyFirstWin;
            break;
        case ResultTypeSecond:
            winKey = keySecondWin;
            break;
        case ResultTypeDraw:
            winKey = keyDraw;
            break;
    }
    
    NSNumber *numWinCount = r[winKey];
    if (!numWinCount) {
        numWinCount = @(0);
    }
    
    NSInteger winCount = [numWinCount integerValue];
    
    return winCount;
}

@end
