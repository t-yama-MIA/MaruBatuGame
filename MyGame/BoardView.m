//
//  BoardView.m
//  MyGame
//
//  Created by トライアローズ開発 on 2016/03/03.
//  Copyright (c) 2016年 トライアローズ開発. All rights reserved.
//

#import "BoardView.h"
#import <QuartzCore/QuartzCore.h>

#import "MasuView.h"

@interface BoardView()<MasuViewDelegate>

// マスの数
@property(nonatomic,assign)NSUInteger masNumber;

// マスの先攻後攻状態
@property(nonatomic,assign)BOOL isFirstState;

// マスViewの配列
@property(nonatomic,strong)NSMutableArray *masViews;

// 結果文字列
@property(nonatomic,strong)CATextLayer *resultLayer;

@end

@implementation BoardView

#pragma mark - initialize

- (instancetype)initWithFrame:(CGRect)frame masNumber:(NSUInteger)masNumber
{
    self = [super initWithFrame:frame];
    if (self) {
        self.masNumber = masNumber;
        
        [self initialize];
        
    }
    return self;
}

- (void)initialize
{
    // 初期化
    self.isFirstState = YES;
    
    self.masViews = [@[] mutableCopy];
    
    // 枠線
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.f;
    
    // デフォルト文字列
    self.firstTitle = @"⚪︎";
    self.secondTitle = @"×";
    
    // マス作成
    [self createMasViews];
}

#pragma mark - private

// マスの生成
- (void)createMasViews
{
    // マスの大きさ(辺の長さ)
    CGFloat masWidth = self.frame.size.width / self.masNumber;
    
    for (NSInteger row = 0; row < self.masNumber; row++) {
        NSMutableArray *rows = [@[] mutableCopy];
        for (NSInteger colmn = 0; colmn < self.masNumber; colmn++) {
            // マスのframe
            CGRect rc = CGRectMake(colmn*masWidth, row*masWidth, masWidth, masWidth);
            
            MasuView *masView = [[MasuView alloc] initWithFrame:rc delegate:self row:row colmn:colmn];
            [self addSubview:masView];
            [rows addObject:masView];
        }
        [self.masViews addObject:rows];
    }
}

/*
 終了判定(マスが全て埋まったか？)
 @return 終了なら1。途中なら0が返る。
 */
- (BOOL)isFinishedGame
{
    if ([self judgeDraw]) {
        return YES;
    }
    
    for (NSMutableArray *rows in self.masViews) {
        for (MasuView *masView in rows) {
            if (!masView.title || masView.title.length == 0) {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - Draw
/*
 引き分け判定
 @return NOなら途中。YESなら引き分け。
*/
- (BOOL)judgeDraw
{
    NSInteger count = 0;
    
    // 横
    if ([self judgeRowDraw]){
        count++;
    }
    
    // 縦
    if ([self judgeColmnDraw]) {
        count++;
    }
    
    // 斜め
    if ([self judgeSlantingDraw]) {
        count++;
    }
    
    if (count == 3) {
        return YES;
    }else{
        return NO;
    }
}

/*
 行(横方向)の引き分け判定
 @return NOなら途中。YESなら引き分け。
 */
- (BOOL)judgeRowDraw
{
    // 全ての横行に◯×の両方が含まれていれば、引き分け
    for (NSMutableArray *rows in self.masViews) {
        BOOL isFirst = NO;
        BOOL isSecond = NO;

        for (MasuView *masView in rows) {
            // tempTitleに文字を一度のみ格納する。
            if ([masView.title isEqualToString:self.firstTitle]) {
                isFirst = YES;
            }else if ([masView.title isEqualToString:self.secondTitle]) {
                isSecond = YES;
            }
        }
        
        // 1つの行に◯もしくは×が含まれていなければ、継続する。
        if (isFirst == NO || isSecond == NO) {
            return NO;
        }
    }
    
    return YES;
}

/*
 列(縦方向)の引き分け判定
 @return NOなら途中。YESなら引き分け。
 */
- (BOOL)judgeColmnDraw
{
    // 全ての縦列に◯×の両方が含まれていれば、引き分け
    for (NSUInteger colmn = 0; colmn < self.masNumber; colmn++) {
        __block BOOL isFirst = NO;
        __block BOOL isSecond = NO;

        [self.masViews enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger idx, BOOL *stop) {
            MasuView *masView = rows[colmn];

            // tempTitleに文字を一度のみ格納する。
            if ([masView.title isEqualToString:self.firstTitle]){
                isFirst = YES;
            }else if ([masView.title isEqualToString:self.secondTitle]){
                isSecond = YES;
            }
        }];
        
        if (isFirst == NO || isSecond == NO) {
            return NO;
        }
    }
    
    return YES;
}

/*
 斜めの引き分け判定
 @return NOなら途中。YESなら引き分け。
 */
- (BOOL)judgeSlantingDraw
{
    __block BOOL isFirst = NO;
    __block BOOL isSecond = NO;
    __block NSUInteger colmn = 0;
    
    // 1回目
    // 対角線なので2回だけ実行
    [self.masViews enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger idx, BOOL *stop) {
        MasuView *masView = rows[colmn];
        // tempTitleに文字を一度のみ格納する。
        if ([masView.title isEqualToString:self.firstTitle]){
            isFirst = YES;
        }else if ([masView.title isEqualToString:self.secondTitle]){
            isSecond = YES;
        }
        
        colmn++;
    }];
    
    if (isFirst == NO || isSecond == NO) {
        return NO;
    }
    
    isFirst = NO;
    isSecond = NO;

    // 2回目
    // 対角線なので2回だけ実行
    colmn = self.masNumber -1;
    
    [self.masViews enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger idx, BOOL *stop) {
        MasuView *masView = rows[colmn];
        // tempTitleに文字を一度のみ格納する。
        if ([masView.title isEqualToString:self.firstTitle]){
            isFirst = YES;
        }else if ([masView.title isEqualToString:self.secondTitle]){
            isSecond = YES;
        }
        
        colmn--;
    }];
    
    if (isFirst == NO || isSecond == NO) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Winner
/*
 勝者判定
 @return 0なら途中。1なら先攻が勝ち。2なら後攻が勝ち。
 */
- (NSInteger)judgeWinner
{
    // よこ
    NSInteger rowWinner = [self judgeRowWinner];
    if (rowWinner != 0) {
        return rowWinner;
    }
    
    // たて
    NSInteger colmnWinner = [self judgeColmnWinner];
    if (colmnWinner != 0) {
        return colmnWinner;
    }
    
    // ななめ
    NSInteger slantingWinner = [self judgeSlantingWinner];
    if (slantingWinner != 0) {
        return slantingWinner;
    }
    
    return 0;
}

/*
 行(横方向)の勝敗判定
 @return 0なら途中。1なら先攻が勝ち。2なら後攻が勝ち。
 */
- (NSInteger)judgeRowWinner
{
    for (NSMutableArray *rows in self.masViews) {
        MasuView *prevView = nil;
        for (MasuView *masView in rows) {
            if (prevView) {
                if (![masView.title isEqualToString:prevView.title]) {
                    break;
                }
                
                // 最後のデータ
                if (masView.colmn == self.masNumber - 1) {
                    // 勝者決定
                   return ([masView.title isEqualToString:self.firstTitle]) ? 1 : 2;
                }
            }
            
            prevView = masView;
        }
    }
    
    return 0;
}

/*
 列(縦方向)の勝敗判定
 @return 0なら途中。1なら先攻が勝ち。2なら後攻が勝ち。
 */
- (NSInteger)judgeColmnWinner
{
    __block MasuView *winnerMasView = nil;
    for (NSUInteger colmn = 0; colmn < self.masNumber; colmn++) {
        __block MasuView *prevView = nil;
        [self.masViews enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger idx, BOOL *stop) {
            MasuView *masView = rows[colmn];
            if (prevView) {
                if (![masView.title isEqualToString:prevView.title]) {
                    *stop = YES;
                    return;
                }

                // 最後のデータ
                if (idx == self.masNumber - 1) {
                    // 勝者決定
                    winnerMasView = masView;
                }
            }
            
            prevView = masView;
        }];
    }
    
    // 勝者
    if (winnerMasView) {
        return ([winnerMasView.title isEqualToString:self.firstTitle]) ? 1 : 2;
    }
    
    return 0;
}

/*
 斜めの勝敗判定
 @return 0なら途中。1なら先攻が勝ち。2なら後攻が勝ち。
 */
- (NSInteger)judgeSlantingWinner
{
    __block MasuView *winnerMasView = nil;
    
    __block NSUInteger colmn = 0;
    
    __block MasuView *prevView = nil;
    
    // 1回目
    // 対角線なので2回だけ実行
    [self.masViews enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger idx, BOOL *stop) {
        MasuView *masView = rows[colmn];
        if (prevView) {
            if (![masView.title isEqualToString:prevView.title]) {
                *stop = YES;
                return;
            }
            
            // 最後のデータ
            if (idx == self.masNumber - 1) {
                // 勝者決定
                winnerMasView = masView;
            }

        }
        
        prevView = masView;
        colmn++;
    }];
    
    // 勝者
    if (winnerMasView) {
        return ([winnerMasView.title isEqualToString:self.firstTitle]) ? 1 : 2;
    }

    // 2回目
    // 対角線なので2回だけ実行
    colmn = self.masNumber -1;
    prevView = nil;

    [self.masViews enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger idx, BOOL *stop) {
        MasuView *masView = rows[colmn];
        if (prevView) {
            if (![masView.title isEqualToString:prevView.title]) {
                *stop = YES;
                return;
            }
            
            // 最後のデータ
            if (idx == self.masNumber - 1) {
                // 勝者決定
                winnerMasView = masView;
            }
            
        }
        
        prevView = masView;
        colmn--;
    }];
    
    // 勝者
    if (winnerMasView) {
        return ([winnerMasView.title isEqualToString:self.firstTitle]) ? 1 : 2;
    }

    return 0;
}

// 結果文字列のアニメーション
- (void)animationResult
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.5];
    self.resultLayer.fontSize = 50;
    [CATransaction commit];
}

// 変更デリゲート
- (void)didChangeBoard
{
    if ([self.delegate respondsToSelector:@selector(didChangeBoardView:)]) {
        [self.delegate didChangeBoardView:self];
    }
}

#pragma mark - MasuViewDelegate

/*
 マスがタップされると呼ばれる
 @param row マスの行
 @param colmn マスの列
 @return マスにセットする文字列を返す。マスの状態を変えない場合はnilをセットする
 */
- (NSString *)masuView:(MasuView *)masuView titleAtRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    if (masuView.title.length != 0) {
        return nil;
    }
    
    NSString *title = (self.isFirstState) ? self.firstTitle : self.secondTitle;
    
    self.isFirstState = !self.isFirstState;
    
    return title;
}

/*
 マスの状態が変更された後に呼ばれる
 */
- (void)didChangeMasuView:(MasuView *)masuView
{
    // 勝者判定
    NSInteger win = [self judgeWinner];
    if (win == 0) {
        if (![self isFinishedGame]) {
            // デリゲート
            [self didChangeBoard];
            return;
        }
    }
    
    // もうタップ不可にする
    self.userInteractionEnabled = NO;
    
    // 終了処理
    NSString *winner = nil;
    switch (win) {
        case 0:
            winner = @"引き分け";
            break;
        case 1:
            winner = @"先攻の勝ち!";
            break;
        case 2:
            winner = @"後攻の勝ち!";
            break;
        default:
            break;
    }
    
    // 勝敗表示
    CGRect rc = self.frame;
    CATextLayer *tl = [CATextLayer layer];
    tl.string  = winner;
    CGFloat fontSize = 1;
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    tl.font = (__bridge CFTypeRef)(font.fontName);
    tl.fontSize = fontSize;
    tl.foregroundColor = [UIColor blueColor].CGColor;
    tl.alignmentMode = kCAAlignmentCenter;
    CGFloat labelHeight = 80.f;
    CGFloat margin = 10.f;
    tl.frame = CGRectMake(margin, rc.size.height/2-labelHeight/2, rc.size.width-margin*2, labelHeight);
    [self.layer addSublayer:tl];
    
    self.resultLayer = tl;
    
    // アニメーション
    [self performSelector:@selector(animationResult) withObject:nil afterDelay:0.1f];
    
    // デリゲート
    // 変更通知も一応出す
    [self didChangeBoard];
    
    // リセット処理を親が実装(GameViewController)
    if ([self.delegate respondsToSelector:@selector(boardView:finishGameWinFirst:)]) {
        [self.delegate boardView:self finishGameWinFirst:win];
    }
}


@end
