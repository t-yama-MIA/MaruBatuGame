//
//  GameViewController.m
//  MyGame
//
//  Created by トライアローズ開発 on 2016/03/03.
//  Copyright (c) 2016年 トライアローズ開発. All rights reserved.
//

#import "GameViewController.h"
#import "BoardView.h"
#import "RecordData.h"


@interface GameViewController ()<BoardViewDelegate>

// 縦横のマス数
@property(nonatomic,assign)NSUInteger masNumber;

// 今の先攻後攻状態
@property(nonatomic,strong)UILabel *playerStateLabel;

@end

@implementation GameViewController

#pragma mark - initialize

- (instancetype)initWithMasuNumber:(NSUInteger)masNumber
{
    self = [super init];
    if (self) {
        [self initialize];
        
        // マス数は最低3
        self.masNumber = (masNumber >= 3)?masNumber:3;
    }
    return self;
}

- (void)initialize
{
    // 初期化
    
}

#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    // メイン画面
    [self createBoardView];
    
    // 先攻後攻状態
    [self createPlayerStateLabel];
    
    // 戻るボタンを付ける
    [self createBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

// プレイヤー状態ラベル
- (void)createPlayerStateLabel
{
    CGRect rc = [[UIScreen mainScreen] applicationFrame];
    CGFloat labelWidth = 50;
    CGFloat labelHeight = 30;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(rc.size.width/2-labelWidth/2, rc.size.height-labelHeight, labelWidth, labelHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = @"先攻";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    self.playerStateLabel = label;
}

// プレイヤー状態ラベル更新
- (void)updatePalayerState:(NSString *)state
{
    self.playerStateLabel.text = state;
}

// メインボードを作成
- (void)createBoardView
{
    CGRect rc = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat margin = 10.f;
    CGFloat width = rc.size.width - margin*2;
    CGRect frame = CGRectMake(margin, 100, width, width);
    
    BoardView *board = [[BoardView alloc] initWithFrame:frame masNumber:self.masNumber];
    board.delegate = self;
    [self.view addSubview:board];
}

// 戻るボタンを付ける
- (void)createBackButton
{
    NSString* title = @"タイトルに戻る";
    
    CGRect rc = [[UIScreen mainScreen] applicationFrame];
    CGFloat btnHeight = 50;
    CGFloat btnWidth = 200;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(rc.size.width/2 - btnWidth/2, 20, btnWidth, btnHeight);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushedBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    btn.exclusiveTouch = YES;
    [self.view addSubview:btn];
}

#pragma mark - Event

- (void)pushedBackButton:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BoardViewDelegate

/*
 勝敗がついたときに呼ばれる
 @param winFirst 先攻が勝者の場合YES.後攻が勝者の場合NO.
 */
- (void)boardView:(BoardView *)boardView finishGameWinFirst:(BOOL)winFirst
{
    // 勝敗記録
    [RecordData saveResult:(winFirst)?ResultTypeFirst:ResultTypeSecond];
}

/*
 マスの状態が変更されたときに呼ばれる
 */
- (void)didChangeBoardView:(BoardView *)boardView
{
    [self updatePalayerState:(boardView.isFirstState)?@"先攻":@"後攻"];
}


@end
