//
//  AVPlayerVC.m
//  DemoVideoPlay
//
//  Created by zhangshaoyu on 16/11/9.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "AVPlayerVC.h"

// 导入头文件
#import "AVMoviePlayer.h"

@interface AVPlayerVC ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation AVPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"AVPlayer"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"play" style:UIBarButtonItemStyleDone target:self action:@selector(playPause:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

#pragma mark - 未封装使用

- (void)dealloc
{
    [self.player pause];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 视频播放完成
- (void)playEndNotification:(NSNotification *)notification
{
    NSLog(@"视频播放完成");
    [self.player seekToTime:kCMTimeZero];
}

// 通过KVO监控播放器的状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay)
        {
            NSLog(@"正在播放:%.2f", CMTimeGetSeconds(playerItem.duration));
        }
    }
    else if([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        NSArray *array = playerItem.loadedTimeRanges;
        // 本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        // 缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f", totalBuffer);
    }
}

- (void)playMovie
{
    // 播放本地视频
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"movie02" ofType:@"mov"];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    // 播放网络视频
//    NSString *urlStr = @"http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8";
//    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (self.player)
    {
        // 已经创建则不再创建
        return;
    }
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = CGRectMake(10.0, 10.0, (self.view.bounds.size.width - 10.0 * 2), 200.0);
    [self.view.layer addSublayer:layer];
    [self.player play];
    
    // 设置KVC 播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEndNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 设置KVO
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 设置每秒执行一次进度更新
    AVPlayerVC __weak *weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        NSLog(@"1 current time = %.2f", current);
        
        float total = CMTimeGetSeconds([weakSelf.player.currentItem duration]);
        NSLog(@"2 total time = %.2f", total);
        
        if (current)
        {
            CGFloat progress = current / total;
            NSLog(@"3 progress = %.2f", progress);
        }
    }];
}

#pragma mark - 封装使用

- (void)playPause:(id)sender
{
    // 未封装
//    [self playMovie];
//    if (self.player.rate == 0)
//    {
//        // 暂停时，继续播放
//        [self.player play];
//    }
//    else if (self.player.rate == 1)
//    {
//        // 正在播放时，暂停
//        [self.player pause];
//    }
    
    
    
    
    
    // 封装
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"movie02" ofType:@"mov"];    
    CGRect rect = CGRectMake(10.0, 10.0, (self.view.bounds.size.width - 10.0 * 2), 200.0);
    AVMoviePlayer *player = [[AVMoviePlayer alloc] initWithFrame:rect];
    [self.view addSubview:player];
    player.videoUrl = urlStr;
    player.videoTitle = @"本地视频";
    
}


@end
