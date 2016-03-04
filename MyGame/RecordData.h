//
//  RecordData.h
//  MyGame
//
//  Created by トライアローズ開発 on 2016/03/04.
//  Copyright (c) 2016年 トライアローズ開発. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ResultType) {
    ResultTypeFirst = 1,
    ResultTypeSecond = 2,
};

@interface RecordData : NSObject

// 保存
+ (void)saveResult:(ResultType)result;

// 呼び出し
+ (NSInteger)loadResult:(ResultType)result;

@end
