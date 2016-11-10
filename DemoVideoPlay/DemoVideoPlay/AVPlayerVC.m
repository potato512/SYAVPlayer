//
//  AVPlayerVC.m
//  DemoVideoPlay
//
//  Created by zhangshaoyu on 16/11/9.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "AVPlayerVC.h"

#import "AVMoviePlayer.h"

@interface AVPlayerVC ()

@property (nonatomic, strong) AVPlayer *moviePlayer;

//@property (weak, nonatomic) UIView *containerView;
//@property (weak, nonatomic) UIButton *palyPause;
//@property (weak, nonatomic) UIProgressView *progress;

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

- (void)dealloc
{
    [self.moviePlayer pause];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 

// 视频播放完成
- (void)playbackFinish:(NSNotification *)notification
{
    NSLog(@"视频播放完成");
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

- (void)playPause:(id)sender
{
//    if (self.moviePlayer.rate == 0)
//    {
//        // 暂停时，继续播放
//        [self.moviePlayer play];
//    }
//    else if (self.moviePlayer.rate == 1)
//    {
//        // 正在播放时，暂停
//        [self.moviePlayer pause];
//    }
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    
    CGRect rect = CGRectMake(10.0, 10.0, (self.view.bounds.size.width - 10.0 * 2), 200.0);
    
    AVMoviePlayer *player = [[AVMoviePlayer alloc] initWithFrame:rect];
    player.backgroundColor = [UIColor greenColor];
    [self.view addSubview:player];
    player.videoUrl = urlStr;
    player.videoTitle = @"本地视频";
    
}

#pragma mark - 

- (AVPlayer *)moviePlayer
{
    if (_moviePlayer == nil)
    {
        /*
        // 播放网络视频
        // 1.创建网络视频路径，或本地视频路径
        NSString *urlStr = @"http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8";        
        // urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // url只支持英文和少数其它字符，因此对url中非标准字符需要进行编码，这个编码方*****能不完善，因此使用下面的方法编码。
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *netUrl = [NSURL URLWithString:urlStr];
        
        // 2.创建AVPlayer
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:netUrl];
        _moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
        // _avPlayer.currentItem;//用于获取当前的AVPlayerItem
        
        // 3.设置每秒执行一次进度更新
//        UIProgressView *progressView = _progress;
//        [_moviePlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//            float current = CMTimeGetSeconds(time);
//            float total = CMTimeGetSeconds([playerItem duration]);
//            if (current)
//            {
//                progressView.progress = current / total;
//            }
//        }];
        
        // 4.监控播放状态
        // 监控状态属性，获取播放状态
        [_moviePlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // 监控网络加载情况
        [_moviePlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        // 5.创建播放层，开始播放视频
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_moviePlayer];
        playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        // 视频填充模式
        // playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.view.layer addSublayer:playerLayer];
//        [_moviePlayer play];
        
        // 7.添加播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:_moviePlayer.currentItem];
        */
        
        
        /*
        // 播放网络视频
        NSString *urlStr = @"http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8";
        NSURL *url = [NSURL URLWithString:urlStr];
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        _moviePlayer = [AVPlayer playerWithPlayerItem:item];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_moviePlayer];
        layer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        [self.view.layer addSublayer:layer];        
        [_moviePlayer play];
        */
        
        
        // 播放本地视频
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
        NSURL *videoURL = [NSURL fileURLWithPath:urlStr];
        _moviePlayer = [AVPlayer playerWithURL:videoURL];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_moviePlayer];
        playerLayer.frame = CGRectMake(10.0, 10.0, 200.0, 80.0);
        [self.view.layer addSublayer:playerLayer];
        [_moviePlayer play];
    }
    
    return _moviePlayer;
}

@end
