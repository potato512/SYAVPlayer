//
//  SYAVPlayerStatusView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYAVPlayerStatusView.h"
#import "SYAVPlayerHeader.h"

@implementation SYAVPlayerStatusView

#pragma mark - 实例化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.frame;
        rect.size.height = heightStatusView;
        self.frame = rect;
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        [self setUI];
        self.viewType = SYAVPlayerStatusViewTypeDefault;
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
    self.playButton.frame = CGRectMake(originX / 2, 0.0, self.frame.size.height, self.frame.size.height);
    [self addSubview:self.playButton];
    
    self.currentTimeLabel.frame = CGRectMake(originX / 2, (self.frame.size.height - heightItem) / 2, widthItem, heightItem);
    [self addSubview:self.currentTimeLabel];
    
    UIView *currentView = self.currentTimeLabel;
    
    self.progressSlider.frame = CGRectMake((currentView.frame.origin.x + currentView.frame.size.width + originX / 2), currentView.frame.origin.y, (self.frame.size.width - originX * 2.5 - widthItem * 2 - heightAction), heightItem);
    [self addSubview:self.progressSlider];
   
    currentView = self.progressSlider;
    
    self.remainsTimeLabel.frame = CGRectMake((currentView.frame.origin.x + currentView.frame.size.width + originX / 2), currentView.frame.origin.y, widthItem, heightItem);
    [self addSubview:self.remainsTimeLabel];
    
    currentView = self.remainsTimeLabel;
    
    self.scaleButton.frame = CGRectMake((self.frame.size.width - heightAction - originX / 2), (self.frame.size.height - heightAction) / 2, heightAction, heightAction);
    [self addSubview:self.scaleButton];
}

#pragma mark - setter

- (void)setViewType:(SYAVPlayerStatusViewType)viewType
{
    _viewType = viewType;
    
    UIView *currentView = self.currentTimeLabel;
    if (_viewType == SYAVPlayerStatusViewTypeBottom) {
        self.playButton.hidden = NO;
        self.currentTimeLabel.hidden = YES;
        
        currentView = self.playButton;
    } else {
        self.playButton.hidden = YES;
        self.currentTimeLabel.hidden = NO;
        
        currentView = self.currentTimeLabel;
    }

    //
    CGRect rect = self.progressSlider.frame;
    rect.origin.x = (currentView.frame.origin.x + currentView.frame.size.width + originX / 2);
    rect.size.width = (self.frame.size.width - currentView.frame.origin.x - currentView.frame.size.width - originX / 2 - originX / 2 - widthItem - originX / 2 - heightAction - originX / 2);
    self.progressSlider.frame = rect;
    
    currentView = self.progressSlider;
    
    rect = self.remainsTimeLabel.frame;
    rect.origin.x = (currentView.frame.origin.x + currentView.frame.size.width + originX / 2);
    self.remainsTimeLabel.frame = rect;
    
    currentView = self.remainsTimeLabel;
    
    rect = self.scaleButton.frame;
    rect.origin.x = (self.frame.size.width - heightAction - originX / 2);
    self.scaleButton.frame = rect;
}


#pragma mark - getter

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

- (UILabel *)currentTimeLabel
{
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc] init];
        
        _currentTimeLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        _currentTimeLabel.font = [UIFont systemFontOfSize:10.0];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _currentTimeLabel;
}

- (UISlider *)progressSlider
{
    if (_progressSlider == nil) {
        _progressSlider = [[UISlider alloc] init];
        
        _progressSlider.continuous = true;
        [_progressSlider setThumbImage:[UIImage imageNamed:@"SYAVPlayer_Control"] forState:UIControlStateNormal];
    }
    
    return _progressSlider;
}

- (UILabel *)remainsTimeLabel
{
    if (_remainsTimeLabel == nil) {
        _remainsTimeLabel = [[UILabel alloc] init];
        
        _remainsTimeLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        _remainsTimeLabel.font = [UIFont systemFontOfSize:10.0];
        _remainsTimeLabel.textColor = [UIColor whiteColor];
        _remainsTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _remainsTimeLabel;
}

- (UIButton *)scaleButton
{
    if (!_scaleButton) {
        _scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _scaleButton.backgroundColor = [UIColor clearColor];
        [_scaleButton setImage:[UIImage imageNamed:@"SYAVPlayer_Zoomin"] forState:UIControlStateNormal];
        [_scaleButton setImage:[UIImage imageNamed:@"SYAVPlayer_Zoomout"] forState:UIControlStateSelected];
    }
    
    return _scaleButton;
}

@end
