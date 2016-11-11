//
//  AVMoviePlayer.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/9.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "AVMoviePlayer.h"
#import "AVMoviePlayerView.h"

@interface AVMoviePlayer () <UIGestureRecognizerDelegate>

// 播放器
@property (nonatomic, strong) NSURL *playerUrl; // 视频地址
@property (nonatomic, assign) BOOL isNetwork;   // 区分网络视频，或本地视频

@property (nonatomic, strong) AVPlayerItem *playerItem;   // 播放对象
@property (nonatomic, strong) AVPlayer *player;           // 播放本地视频
@property (nonatomic, strong) AVPlayerLayer *playerLayer; // 播放视频层

/// 视频播放前的背景图标
@property (nonatomic, strong) UIImageView *backgroundImageView;
// 视图
@property (nonatomic, strong) AVMoviePlayerView *playerView; // 播放播放、状态视图

// 播放控制
@property (nonatomic, assign) NSTimeInterval playerTotalTime;   // 视频总时长
@property (nonatomic ,strong) id timeObserver;                  // 时间观察者
@property (nonatomic, assign) BOOL isSliderDraging;             // 正在拖动，用于控制拖动操作时的处理（正在播放时，才会有正在拖动）
@property (nonatomic, strong) NSTimer *playerTimer;             // 播放定时器
@property (nonatomic, assign) NSTimeInterval lastPlayDuration;  // 切到后台前最后播放的时间
@property (nonatomic, assign) BOOL isShowInfo;                  // 是否显示或隐藏操作视图
@property (nonatomic, assign) BOOL isloading;                   // 首次播放加载时，显示加载

@end

@implementation AVMoviePlayer

#pragma mark - 实例化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizesSubviews = YES;
        [self setUI];
        
        // 添加手势
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tapRecognizer.delegate = self;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)dealloc
{
    [self removeNotification];
    [self removeKVO];
    [self removeTimerObserver];
}

#pragma mark - 视图

- (void)setUI
{
    self.backgroundImageView.image = [UIImage imageNamed:@"SYAVPlayer_bgroundImage"];
    [self addSubview:self.backgroundImageView];
    
    [self addSubview:self.playerView];
}

#pragma mark - 响应事件

- (void)playMovie:(UIButton *)button
{
    button.selected = !button.selected;
    
    [self playLocalMovie];
}

- (void)scaleMovie:(UIButton *)button
{
    if (self.scaleScreen)
    {
        button.selected = !button.selected;
        self.frame = (button.selected ? CGRectZero : self.superview.bounds);
        self.scaleScreen(button.selected);
    }
}

- (void)slideMovie:(UISlider *)slider
{
    CGFloat progress = slider.value;
    
    // 重置播放进度状态
    NSTimeInterval currentTime = (progress * self.playerTotalTime);
    [self.player seekToTime:CMTimeMake(currentTime, 1.0)];
    [self refreshPlayerUIWithTime:currentTime totalTime:self.playerTotalTime slider:NO];
}

- (void)slideBeginMovie:(UISlider *)slider
{
    NSLog(@"slider 开始拖动");
    
    [self removeTimerObserver];
    if (self.player.rate == 1.0)
    {
        // 如果拖动进度条时，正在播放，则先停止播放，同时移除时间观察者
        self.isSliderDraging = YES;
        [self.player pause];
    }
}

- (void)slideEndMovie:(UISlider *)slider
{
    NSLog(@"slider 结束拖动");
    
    [self addTimerObserver];
    if (self.isSliderDraging)
    {
        self.isSliderDraging = NO;
        [self.player play];
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了slider），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UISlider"])
    {
        return NO;
    }
    
    return  YES;
}

- (void)tapClick:(UITapGestureRecognizer *)recognizer
{
    self.playerView.playerActionView.hidden = !self.playerView.playerActionView.hidden;
    self.playerView.playerStatusView.hidden = !self.playerView.playerStatusView.hidden;
    self.playerView.progressView.hidden = !self.playerView.progressView.hidden;
}

#pragma mark KVC

- (void)addNotification
{
    // 播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEndNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playJumpNotification:) name:AVPlayerItemTimeJumpedNotification object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    // 播放进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnterBgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)playEndNotification:(NSNotification *)notification
{
    NSLog(@"播放结束");

    // 设置播放前的状态
    [self.player seekToTime:kCMTimeZero];
    self.playerView.playerActionView.playButton.selected = NO;
    [self refreshPlayerUIWithTime:0.0 totalTime:self.playerTotalTime slider:YES];
}

- (void)playJumpNotification:(NSNotification *)notification
{
    NSLog(@"播放跳跃");
    
}

- (void)playBackStalledNotification:(NSNotification *)notification
{
    NSLog(@"播放结束");
    
}

- (void)playEnterBgroundNotification:(NSNotification *)notification
{
    NSLog(@"播放进入后台");
    
}

#pragma mark KVO

- (void)addKVO
{
    // 监控状态属性，获取播放状态
    [self.playerItem addObserver:self forKeyPath:SYAVPlayerStatus options:NSKeyValueObservingOptionNew context:nil];
    // 监控网络加载情况
//    [self.playerItem addObserver:self forKeyPath:playerNetwork options:NSKeyValueObservingOptionNew context:nil];
//    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKVO
{
    [self.playerItem removeObserver:self forKeyPath:SYAVPlayerStatus];
//    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:SYAVPlayerStatus])
    {
        AVPlayerItemStatus status = self.playerItem.status;
        switch (status)
        {
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"AVPlayerItemStatusReadyToPlay");
                
                // 设置播放前的状态
                NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
                self.playerTotalTime = CMTimeGetSeconds(self.player.currentItem.duration);
                [self refreshPlayerUIWithTime:current totalTime:self.playerTotalTime slider:YES];
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"AVPlayerItemStatusUnknown");
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"AVPlayerItemStatusFailed");
                NSLog(@"%@", self.playerItem.error);
            }
                break;
                
            default:
                break;
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        
    }
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        
    }
}

#pragma mark TimerObserver

- (void)addTimerObserver
{
    // 设置每秒执行一次进度更新
    SYAVPlayerSelfWeak;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSTimeInterval current = CMTimeGetSeconds(time);
        NSLog(@"1 current time = %f", current);
        NSLog(@"2 total time = %f", SYAVPlayerWeakSelf.playerTotalTime);
        NSLog(@"3 progress = %f", (current / SYAVPlayerWeakSelf.playerTotalTime));
        NSLog(@"4 rate = %@", @(SYAVPlayerWeakSelf.player.rate));
        
        [SYAVPlayerWeakSelf refreshPlayerUIWithTime:current totalTime:SYAVPlayerWeakSelf.playerTotalTime slider:YES];
    }];
}

- (void)removeTimerObserver
{
    [self.player removeTimeObserver:self.timeObserver];
}

#pragma mark - 播放器

- (void)setPlayerUI
{
    NSAssert(_videoUrl != nil, @"视频地址不能为空!");

    self.playerLayer.frame = self.bounds;
    [self.layer addSublayer:self.playerLayer];
    
    [self refresuPlayerUI];
    
    [self bringSubviewToFront:self.playerView];
}

- (void)refresuPlayerUI
{
    // 添加KVO
    [self addKVO];
    
    // 添加KVC
    [self addNotification];
    
    // 添加timerObserver
    [self addTimerObserver];
}

- (void)refreshPlayerUIWithTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime slider:(BOOL)isSlider
{
    // 播放当前时间
    NSString *currentStr = [AVMoviePlayerTools timeStringWithSecond:currentTime prefix:@""];
    self.playerView.playerStatusView.currentTimeLabel.text = currentStr;
    
    // 播放剩余时间
    float remainTime = (totalTime - currentTime);
    NSString *remainStr = [AVMoviePlayerTools timeStringWithSecond:remainTime prefix:@"-"];
    self.playerView.playerStatusView.remainsTimeLabel.text = remainStr;
    
    // 播放进度
    float progress = currentTime / totalTime;
    self.playerView.progressView.progress = progress;
    if (isSlider)
    {
        // 拖动slider时，不需要改变；只有播放时才需要改变
        self.playerView.playerStatusView.progressSlider.value = progress;
    }
}

- (void)playNetworkMovie
{
    
}

- (void)playLocalMovie
{
    if (self.player.rate == 0.0)
    {
        // 暂停时，继续播放
        [self.player play];
    }
    else if (self.player.rate == 1.0)
    {
        // 正在播放时，暂停
        [self.player pause];
    }
}

#pragma mark - setter

- (void)setVideoUrl:(NSString *)videoUrl
{
    _videoUrl = videoUrl;
    [self setPlayerUI];
}

- (void)setVideoTitle:(NSString *)videoTitle
{
    _videoTitle = videoTitle;
    if (_videoTitle && 0 != _videoTitle.length)
    {
        self.playerView.playerActionView.titleLabel.text = _videoTitle;
    }
}


#pragma mark - getter

#pragma mark 播放

- (NSURL *)playerUrl
{
    if ([self.videoUrl hasPrefix:@"http://"] || [self.videoUrl hasPrefix:@"https://"])
    {
        // 网络视频
        NSString *urlStr = [self.videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        return url;
    }

    // 本地视频
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoUrl])
    {
        NSURL *url = [NSURL fileURLWithPath:self.videoUrl];
        return url;
    }
    return nil;
}

- (BOOL)isNetwork
{
    if ([self.videoUrl hasPrefix:@"http://"] || [self.videoUrl hasPrefix:@"https://"])
    {
        // 网络视频
        return YES;
    }

    // 本地视频
    return NO;
}

- (AVPlayerItem *)playerItem
{
    if (_playerItem == nil)
    {
        _playerItem = [[AVPlayerItem alloc] initWithURL:self.playerUrl];
    }
    
    return _playerItem;
}

- (AVPlayer *)player
{
    if (_player == nil)
    {
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    
    return _player;
}

- (AVPlayerLayer *)playerLayer
{
    if (_playerLayer == nil)
    {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        // 视频填充模式
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    
    return _playerLayer;
}

#pragma mark 视图

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil)
    {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        // 去除视图界外的图标
        _backgroundImageView.clipsToBounds = YES;
        _backgroundImageView.backgroundColor = [UIColor clearColor];
    }
    
    return _backgroundImageView;
}

- (AVMoviePlayerView *)playerView
{
    if (_playerView == nil)
    {
        _playerView = [[AVMoviePlayerView alloc] initWithFrame:self.bounds];
        
        [_playerView.playerActionView.playButton addTarget:self action:@selector(playMovie:) forControlEvents:UIControlEventTouchUpInside];
        [_playerView.playerStatusView.scaleButton addTarget:self action:@selector(scaleMovie:) forControlEvents:UIControlEventTouchUpInside];
        [_playerView.playerStatusView.progressSlider addTarget:self action:@selector(slideMovie:) forControlEvents:UIControlEventValueChanged];
        [_playerView.playerStatusView.progressSlider addTarget:self action:@selector(slideBeginMovie:) forControlEvents:UIControlEventTouchDown];
        [_playerView.playerStatusView.progressSlider addTarget:self action:@selector(slideEndMovie:) forControlEvents:UIControlEventTouchUpOutside];
        [_playerView.playerStatusView.progressSlider addTarget:self action:@selector(slideEndMovie:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _playerView;
}

@end
