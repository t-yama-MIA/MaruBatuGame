//
//  BoardView.h
//  MyGame
//
//  Created by トライアローズ開発 on 2016/03/03.
//  Copyright (c) 2016年 トライアローズ開発. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordData.h"

@protocol BoardViewDelegate;

/**
 メインのゲームView
 */
@interface BoardView : UIView

// デリゲート
@property(nonatomic,weak)id<BoardViewDelegate> delegate;

// 先攻の文字列(default=⚪︎)
@property(nonatomic,strong)NSString *firstTitle;

// 後攻の文字列(default=×)
@property(nonatomic,strong)NSString *secondTitle;

// マスの先攻後攻状態
@property(nonatomic,assign,readonly)BOOL isFirstState;

/**
 初期化(必須)
 @param frame フレーム
 @param masNumber 縦横のマス数
 */
- (instancetype)initWithFrame:(CGRect)frame masNumber:(NSUInteger)masNumber;


@end


@protocol BoardViewDelegate <NSObject>
 @required
/**
 勝敗がついたときに呼ばれる
 @param resultType 勝敗を表すENUMの値
 */
- (void)boardView:(BoardView *)boardView finishGameWinFirst:(ResultType)resultType;

 @optional
/**
 マスの状態が変更されたときに呼ばれる
 */
- (void)didChangeBoardView:(BoardView *)boardView;

@end