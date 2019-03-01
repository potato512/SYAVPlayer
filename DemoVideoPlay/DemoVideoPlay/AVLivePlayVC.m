//
//  AVLivePlayVC.m
//  DemoVideoPlay
//
//  Created by zhangshaoyu on 2019/3/1.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "AVLivePlayVC.h"
#import "SYVideo.h"

@interface AVLivePlayVC ()

@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) SYLivePlayer *livePlayer;

@end

@implementation AVLivePlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [NSString stringWithFormat:@"视频直播"];

    UIBarButtonItem *itemPlay = [[UIBarButtonItem alloc] initWithTitle:@"play" style:UIBarButtonItemStyleDone target:self action:@selector(playClick)];
    UIBarButtonItem *itemPause = [[UIBarButtonItem alloc] initWithTitle:@"pause" style:UIBarButtonItemStyleDone target:self action:@selector(pauseClick)];
    UIBarButtonItem *itemStop = [[UIBarButtonItem alloc] initWithTitle:@"stop" style:UIBarButtonItemStyleDone target:self action:@selector(stopClick)];
    self.navigationItem.rightBarButtonItems = @[itemPlay, itemStop, itemPause];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)cacheClick
{
    
}

#pragma mark - 播放

- (SYLivePlayer *)livePlayer
{
    if (_livePlayer == nil) {
        _livePlayer = [[SYLivePlayer alloc] init];
        _livePlayer.cacheVideo = YES;
        //
        AVLivePlayVC __weak *weakSelf = self;
        _livePlayer.playComplete = ^(PLPlayerStatus status) {
            [weakSelf showMessage:status];
        };
    }
    return _livePlayer;
}

- (void)playClick
{
    NSString *urlText = @"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8";
//    urlText = @"http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8";
//    urlText = @"rtmp://192.168.43.59/live/record1";
//    urlText = @"http://221.228.226.23/11/t/j/v/b/tjvbwspwhqdmgouolposcsfafpedmb/sh.yinyuetai.com/691201536EE4912BF7E4F1E2C67B8119.mp4";
//    urlText = @"http://221.228.226.5/14/z/w/y/y/zwyyobhyqvmwslabxyoaixvyubmekc/sh.yinyuetai.com/4599015ED06F94848EBF877EAAE13886.mp4";
    urlText = @"http://demo-videos.qnsdk.com/movies/moon.mp4";
//    urlText = @"rtmp://139.9.29.150:1935/hls/test";
    
    
    [self.livePlayer playWithUrl:urlText view:self.playView];
}

- (void)pauseClick
{
    [self.livePlayer pause];
}

- (void)stopClick
{
    [self.livePlayer stop];
}

- (void)scaleClick:(UIButton *)button
{
    //    button.selected = !button.selected;
    //    if (self.streamPlayer) {
    //        [self.streamPlayer fullScreen:button.selected];
    //        self.navigationController.navigationBarHidden = button.selected;
    //    }
    
}

#pragma mark - 播放状态

- (UIView *)playView
{
    if (_playView == nil) {
        _playView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width)];
        [self.view addSubview:_playView];
        _playView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 20.0, 80.0, 40.0)];
        [_playView addSubview:button];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"全屏" forState:UIControlStateNormal];
        [button setTitle:@"关闭全屏" forState:UIControlStateSelected];
        [button addTarget:self action:@selector(scaleClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playView;
}

- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor redColor];
        _messageLabel.font = [UIFont systemFontOfSize:20.0];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor clearColor];
    }
    return _messageLabel;
}

- (void)showMessage:(PLPlayerStatus)state
{
    if (self.messageLabel.superview == nil) {
        [self.playView addSubview:self.messageLabel];
        self.messageLabel.frame = self.playView.bounds;
        [self.playView bringSubviewToFront:self.messageLabel];
    }
    
    if (state == PLPlayerStatusUnknow) {
        // init 后的初始状态
        NSLog(@"1 state = %@", @(state));
        self.messageLabel.text = @"正在初始化";
        self.messageLabel.hidden = NO;
    } else if (state == PLPlayerStatusPreparing) {
        // 调用 -play 方法时出现
        NSLog(@"1 state = %@", @(state));
        self.messageLabel.text = @"准备播放1";
        self.messageLabel.hidden = NO;
    } else if (state == PLPlayerStatusReady) {
        // 调用 -play 方法时出现
        self.messageLabel.text = @"准备播放2";
        self.messageLabel.hidden = NO;
    } else if (state == PLPlayerStatusOpen) {
        // 准备开始连接
        self.messageLabel.text = @"准备开始连接";
        self.messageLabel.hidden = NO;
    } else if (state == PLPlayerStatusCaching) {
        // 缓存数据为空状态
        self.messageLabel.text = @"正在缓冲...";
        self.messageLabel.hidden = NO;
    } else if (state == PLPlayerStatusPlaying) {
        // 正在播放状态
        self.messageLabel.text = @"正在播放化";
        self.messageLabel.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.messageLabel.hidden = YES;
        }];
    } else if (state == PLPlayerStatusPaused) {
        // 暂停状态
        self.messageLabel.text = @"暂停播放";
        self.messageLabel.hidden = NO;
    } else if (state == PLPlayerStatusStopped) {
        // 停止状态
        self.messageLabel.text = @"停止播放";
        self.messageLabel.hidden = NO;
    } else if (state == PLPlayerStatusError) {
        // 播放出现错误时会出现此状态
        self.messageLabel.text = @"播放出现错误";
        self.messageLabel.hidden = NO;
    } else if (state == PLPlayerStateAutoReconnecting) {
        // 自动重连的状态
        self.messageLabel.text = @"正在自动重连";
        self.messageLabel.hidden = NO;
    } else if (state == PLPlayerStatusCompleted) {
        // 播放完成（该状态只针对点播有效）
        self.messageLabel.text = @"播放完成";
        self.messageLabel.hidden = NO;
    }
}

@end
