//
//  MasuView.h
//  MyGame
//
//  Created by トライアローズ開発 on 2016/03/03.
//  Copyright (c) 2016年 トライアローズ開発. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MasuViewDelegate;

/**
 1つのマスを表現するクラス
 タップできて⚪︎か×を入れられる
 */
@interface MasuView : UIView

// 初期化(任意)
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MasuViewDelegate>)delegate row:(NSUInteger)row colmn:(NSUInteger)colmn;

// デリゲート
@property(nonatomic,weak)id<MasuViewDelegate> delegate;

// row
@property(nonatomic,assign)NSUInteger row;

// colmn
@property(nonatomic,assign)NSUInteger colmn;

// 入っている文字列を取得
@property(nonatomic,weak,readonly)NSString *title;

@end

@protocol MasuViewDelegate<NSObject>
 @optional
/**
 マスがタップされると呼ばれる
 @param row マスの行
 @param colmn マスの列
 @return マスにセットする文字列を返す。マスの状態を変えない場合はnilをセットする
 */
- (NSString *)masuView:(MasuView *)masuView titleAtRow:(NSUInteger)row colmn:(NSUInteger)colmn;

/**
 マスの状態が変更された後に呼ばれる
 */
- (void)didChangeMasuView:(MasuView *)masuView;

@end