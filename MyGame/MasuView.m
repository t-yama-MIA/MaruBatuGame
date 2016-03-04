//
//  MasuView.m
//  MyGame
//
//  Created by トライアローズ開発 on 2016/03/03.
//  Copyright (c) 2016年 トライアローズ開発. All rights reserved.
//

#import "MasuView.h"
#import <QuartzCore/QuartzCore.h>

@interface MasuView()

// メインボタン
@property(nonatomic,strong)UIButton *mainButton;

// 

@end

@implementation MasuView

#pragma mark - initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MasuViewDelegate>)delegate row:(NSUInteger)row colmn:(NSUInteger)colmn
{
    self = [self initWithFrame:frame];
    if (self) {
        [self initialize];
        
        self.delegate = delegate;
        self.row = row;
        self.colmn = colmn;
    }
    
    return self;
}

- (void)initialize
{
    // 初期化
    self.backgroundColor = [UIColor redColor];
    
    // 枠線
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5f;
    
    // メインボタン
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.bounds;
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tapMainButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.minimumScaleFactor = 0.001;
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:50];
    btn.exclusiveTouch = YES;
    [self addSubview:btn];
    
    self.mainButton = btn;
    
}

#pragma mark - override

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    // ボタンのサイズを合わせる
    self.mainButton.frame = self.bounds;
}

- (NSString *)title
{
    return self.mainButton.titleLabel.text;
}

#pragma mark - Private

#pragma mark - Event

- (void)tapMainButton:(id)button
{
    NSString *title = self.mainButton.titleLabel.text;
    NSString *newTitle = title;
    
    if ([self.delegate respondsToSelector:@selector(masuView:titleAtRow:colmn:)]) {
        newTitle = [self.delegate masuView:self titleAtRow:self.row colmn:self.colmn];
    }
    
    if (newTitle) {
        [self.mainButton setTitle:newTitle forState:UIControlStateNormal];
    }
    
    // マス変更後
    if ([self.delegate respondsToSelector:@selector(didChangeMasuView:)]) {
        [self.delegate didChangeMasuView:self];
    }
}

@end
