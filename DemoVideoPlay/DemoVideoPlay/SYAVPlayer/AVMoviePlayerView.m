//
//  AVMoviePlayerView.m
//  DemoVideoPlay
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "AVMoviePlayerView.h"
#import "AVMoviePlayerHeader.h"

@implementation AVMoviePlayerView

#pragma mark - 实例化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

#pragma mark - 视图

- (void)setUI
{
    [self addSubview:self.playerActionView];
    [self addSubview:self.playerStatusView];
    
    self.progressView.frame = CGRectMake(0.0, (self.frame.size.height - 5.0), self.frame.size.width, 5.0);
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.progressView];
    
    // 初始化时状态
    self.playerActionView.hidden = NO;
    self.playerStatusView.hidden = NO;
    self.progressView.hidden = YES;
}

#pragma mark - getter

- (AVMoviePlayerActionView *)playerActionView
{
    if (_playerActionView == nil)
    {
        _playerActionView = [[AVMoviePlayerActionView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, (self.bounds.size.height - heightStatusView))];
    }
    
    return _playerActionView;
}

- (AVMoviePlayerStatusView *)playerStatusView
{
    if (_playerStatusView == nil)
    {
        _playerStatusView = [[AVMoviePlayerStatusView alloc] initWithFrame:CGRectMake(0.0, (self.bounds.size.height - heightStatusView), self.bounds.size.width, heightStatusView)];
    }
    
    return _playerStatusView;
}

- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 3.0);
        _progressView.transform = transform;
    }
    
    return _progressView;
}


@end
