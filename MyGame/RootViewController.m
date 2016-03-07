//
//  RootViewController.m
//  MyGame
//
//  Created by トライアローズ開発 on 2016/03/03.
//  Copyright (c) 2016年 トライアローズ開発. All rights reserved.
//

#import "RootViewController.h"

#import "GameViewController.h"
#import "RecordData.h"


@interface RootViewController ()

// 勝敗
@property(nonatomic,strong)UILabel *resultLabel;

@end

@implementation RootViewController

#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self createTitleLabels];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self updateResult];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    // 初期化
    
}

#pragma mark - Private methods

/*
 タイトルラベル生成
 */
- (void)createTitleLabels
{
    CGRect rc = [[UIScreen mainScreen] applicationFrame];
    
    // center
    CGPoint center = CGPointMake(rc.size.width/2, rc.size.height/2);
    
    // title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, rc.size.width, 50)];
    title.backgroundColor = [UIColor clearColor];
    title.text = @"まるばつゲームwww";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:30];
    title.center = CGPointMake(center.x, center.y - 100);
    [self.view addSubview:title];
    
    // 3x3
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 100, rc.size.width, 50);
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:@"3x3マス" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tap3Button:) forControlEvents:UIControlEventTouchUpInside];
        btn.exclusiveTouch = YES;
        btn.center = CGPointMake(center.x, center.y + 50);
        [self.view addSubview:btn];
    }
    
    // 4x4
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 150, rc.size.width, 50);
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:@"4x4マス" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tap4Button:) forControlEvents:UIControlEventTouchUpInside];
        btn.exclusiveTouch = YES;
        btn.center = CGPointMake(center.x, center.y + 100);
        [self.view addSubview:btn];
    }
    
    // 5x5
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 200, rc.size.width, 50);
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:@"5x5マス" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tap5Button:) forControlEvents:UIControlEventTouchUpInside];
        btn.exclusiveTouch = YES;
        btn.center = CGPointMake(center.x, center.y + 150);
        [self.view addSubview:btn];
    }
    
}

// 勝敗更新
- (void)updateResult
{
    NSInteger firstWin = [RecordData loadResult:ResultTypeFirst];
    NSInteger secondWin = [RecordData loadResult:ResultTypeSecond];
    NSInteger draw = [RecordData loadResult:ResultTypeDraw];

    if (!self.resultLabel) {
        
        CGRect rc = [[UIScreen mainScreen] applicationFrame];
        UILabel *rLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rc.size.height-30, rc.size.width, 30)];
        rLabel.backgroundColor = [UIColor clearColor];
        rLabel.textColor = [UIColor whiteColor];
        rLabel.font = [UIFont boldSystemFontOfSize:16];
        rLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:rLabel];
        self.resultLabel = rLabel;
    }
    
    self.resultLabel.text = [NSString stringWithFormat:@"先攻:%ld勝 後攻:%ld勝 引き分け:%ld",firstWin,secondWin,draw];
}

#pragma mark - Event

- (void)tap3Button:(id)sender
{
    NSLog(@"3x3マス");
    
    GameViewController *vc = [[GameViewController alloc] initWithMasuNumber:3];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tap4Button:(id)sender
{
    NSLog(@"4x4マス");
    
    GameViewController *vc = [[GameViewController alloc] initWithMasuNumber:4];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tap5Button:(id)sender
{
    NSLog(@"5x5マス");
    
    GameViewController *vc = [[GameViewController alloc] initWithMasuNumber:5];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
