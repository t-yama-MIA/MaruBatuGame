//
//  GameViewController.h
//  MyGame
//
//  Created by トライアローズ開発 on 2016/03/03.
//  Copyright (c) 2016年 トライアローズ開発. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 メインのゲーム画面を表示する
 */
@interface GameViewController : UIViewController

/**
 初期化メソッド(必須)
 @param masNumber 縦横のマス数
 */
- (instancetype)initWithMasuNumber:(NSUInteger)masNumber;

@end
