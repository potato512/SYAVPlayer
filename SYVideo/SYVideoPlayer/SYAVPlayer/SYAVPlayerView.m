//
//  SYAVPlayerView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYAVPlayerView.h"
#import "SYAVPlayerHeader.h"

static CGFloat const heightProgress = 3.0;

@implementation SYAVPlayerView

#pragma mark - 实例化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        [self setUI];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"释放了 %@~", self.class);
}

#pragma mark - 视图

- (void)setUI
{
    [self addSubview:self.playerActionView];
    [self addSubview:self.playerStatusView];
    
    self.progressView.frame = CGRectMake(0.0, (self.frame.size.height - heightProgress), self.frame.size.width, heightProgress);
    [self addSubview:self.progressView];
    
    // 初始化时状态
    self.playerActionView.hidden = NO;
    self.playerStatusView.hidden = NO;
    self.progressView.hidden = YES;
}

#pragma mark - setter

- (void)setViewType:(SYAVPlayerStatusViewType)viewType
{
    _viewType = viewType;
    self.playerStatusView.viewType = _viewType;
    if (_viewType == SYAVPlayerStatusViewTypeBottom) {
        self.playerActionView.hidden = YES;
    } else {
        self.playerActionView.hidden = NO;
    }
}

#pragma mark - getter

- (SYAVPlayerActionView *)playerActionView
{
    if (_playerActionView == nil) {
        _playerActionView = [[SYAVPlayerActionView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, (self.bounds.size.height - heightStatusView - 1.0))];
    }
    
    return _playerActionView;
}

- (SYAVPlayerStatusView *)playerStatusView
{
    if (_playerStatusView == nil) {
        _playerStatusView = [[SYAVPlayerStatusView alloc] initWithFrame:CGRectMake(0.0, (self.bounds.size.height - heightStatusView), self.bounds.size.width, heightStatusView)];
    }
    
    return _playerStatusView;
}

- (SYAVPlayerProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[SYAVPlayerProgressView alloc] initWithFrame:CGRectZero];
    }
    
    return _progressView;
}


@end
