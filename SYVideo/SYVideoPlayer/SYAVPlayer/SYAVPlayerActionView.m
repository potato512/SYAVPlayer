//
//  SYAVPlayerActionView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYAVPlayerActionView.h"
#import "SYAVPlayerHeader.h"

@implementation SYAVPlayerActionView

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
    self.titleLabel.frame = CGRectMake(originX, originY, (self.frame.size.width - originX * 2), (heightItem * 2));
    [self addSubview:self.titleLabel];
    
    self.networkLabel.frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    [self addSubview:self.networkLabel];
    
    self.cacheView.frame = CGRectMake((self.frame.size.width - sizeButton) / 2, (self.frame.size.height - sizeButton) / 2, sizeButton, sizeButton);
    [self addSubview:self.cacheView];
  
    self.playButton.frame = CGRectMake((self.frame.size.width - sizeButton) / 2, ((self.frame.size.height + heightStatusView - sizeButton) / 2), sizeButton, sizeButton);
    [self addSubview:self.playButton];
    
    self.cacheView.hidden = YES;
    [self.cacheView stopAnimating];
}

#pragma mark - getter

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, (CGRectGetWidth(self.bounds) - originX * 2), 40.0)];
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 2;
    }
    
    return _titleLabel;
}

- (UILabel *)networkLabel
{
    if (_networkLabel == nil) {
        _networkLabel = [[UILabel alloc] init];
        
        _networkLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        _networkLabel.textColor = [UIColor blackColor];
        _networkLabel.font = [UIFont systemFontOfSize:12.0];
        _networkLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _networkLabel;
}

- (UIActivityIndicatorView *)cacheView
{
    if (_cacheView == nil) {
        _cacheView = [[UIActivityIndicatorView alloc] init];
        _cacheView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        _cacheView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    
    return _cacheView;
}

- (UIButton *)playButton
{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _playButton.backgroundColor = [UIColor clearColor];
        [_playButton setImage:[UIImage imageNamed:@"SYAVPlayer_Play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"SYAVPlayer_Stop"] forState:UIControlStateSelected];
    }
    
    return _playButton;
}

@end
