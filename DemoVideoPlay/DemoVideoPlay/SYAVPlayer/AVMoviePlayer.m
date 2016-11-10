//
//  AVMoviePlayer.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/9.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "AVMoviePlayer.h"
#import "AVMoviePlayerHeader.h"
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

// 定时
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeKVO];
}

#pragma mark - 视图

- (void)setUI
{
    self.backgroundImageView.image = [UIImage imageNamed:@"SYAVPlayer_bgroundImage"];
    [self addSubview:self.backgroundImageView];
    
    [self addSubview:self.playerView];
}


#pragma mark - 通知

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionNotification) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)actionNotification
{
    NSLog(@"播放完成");
    
    if (self.playerLayer.superlayer)
    {
        [self.playerLayer removeFromSuperlayer];
    }
}

#pragma mark - 响应事件

- (void)playMovie:(UIButton *)button
{
    button.selected = !button.selected;
    
    [self playLocalMovie];
}

- (void)scaleMovie:(UIButton *)button
{
    button.selected = !button.selected;
}

- (void)slideMovie:(UISlider *)slider
{
    
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
    self.playerView.hidden = !self.playerView.hidden;
}

#pragma mark KVO

- (void)addKVO
{
    // 监控状态属性，获取播放状态
    [self.playerItem addObserver:self forKeyPath:SYAVPlayerStatus options:NSKeyValueObservingOptionNew context:nil];
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
                
//                [self.player play];
//                _videoLength = floor(self.playerItem.asset.duration.value * 1.0 / self.playerItem.asset.duration.timescale);
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


#pragma mark - 播放器

- (void)setPlayerUI
{
    NSAssert(_videoUrl != nil, @"视频地址不能为空!");
    
    self.playerLayer.frame = self.bounds;
    [self.layer addSublayer:self.playerLayer];
    
    [self addKVO];
    
    [self bringSubviewToFront:self.playerView];
}

- (void)playNetworkMovie
{
    
}

- (void)playLocalMovie
{
    if (self.player.rate == 0)
    {
        // 暂停时，继续播放
        [self.player play];
    }
    else if (self.player.rate == 1)
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


/*
- (AVPlayer *)playerNetwork
{
    if (_playerNetwork == nil)
    {
        // AVPlayer
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.urlPlayer];
        _playerNetwork = [AVPlayer playerWithPlayerItem:playerItem];
        // _avPlayer.currentItem;//用于获取当前的AVPlayerItem
        
//         3.设置每秒执行一次进度更新
//                UIProgressView *progressView = _progress;
//                [_moviePlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//                    float current = CMTimeGetSeconds(time);
//                    float total = CMTimeGetSeconds([playerItem duration]);
//                    if (current)
//                    {
//                        progressView.progress = current / total;
//                    }
//                }];
        
        // 监控播放状态
        // 监控状态属性，获取播放状态
        [_playerNetwork.currentItem addObserver:self forKeyPath:playerStatus options:NSKeyValueObservingOptionNew context:nil];
        // 监控网络加载情况
        [_playerNetwork.currentItem addObserver:self forKeyPath:playerNetwork options:NSKeyValueObservingOptionNew context:nil];
        
//        // 5.创建播放层，开始播放视频
//        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_moviePlayer];
//        playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//
//        [self.view.layer addSublayer:playerLayer];
//        // [_moviePlayer play];
        
    }
    
    return _playerNetwork;
}
*/

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
    }
    
    return _playerView;
}

@end
