//
//  ViewController.m
//  DemoVideoStrem
//
//  Created by zhangshaoyu on 2019/1/4.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "StreamPlayer.h"
#import "SYCacheFileViewController.h"
#import "ScreenRecorderUtil/ScreenRecorderUtil.h"

@interface ViewController () <ScreenRecorderDelegate>

@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) StreamPlayer *streamPlayer;

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *shotImage;
@property (nonatomic, strong) UIButton *recordStartStop;
@property (nonatomic, strong) UIButton *recordPauseResume;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) ScreenRecorderUtil *recorderUtil;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = [NSString stringWithFormat:@"视频直播:%@", self.urlTitle];
    //
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"cache" style:UIBarButtonItemStyleDone target:self action:@selector(cacheClick)];
    //
    UIBarButtonItem *itemPlay = [[UIBarButtonItem alloc] initWithTitle:@"play" style:UIBarButtonItemStyleDone target:self action:@selector(playClick)];
    UIBarButtonItem *itemPause = [[UIBarButtonItem alloc] initWithTitle:@"pause" style:UIBarButtonItemStyleDone target:self action:@selector(pauseClick)];
    UIBarButtonItem *itemStop = [[UIBarButtonItem alloc] initWithTitle:@"stop" style:UIBarButtonItemStyleDone target:self action:@selector(stopClick)];
    self.navigationItem.rightBarButtonItems = @[itemPlay, itemStop, itemPause];
    //
    [self.view addSubview:self.playView];
    [self.view addSubview:self.shotImage];
    [self.view addSubview:self.recordStartStop];
    [self.view addSubview:self.recordPauseResume];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)cacheClick
{
    SYCacheFileViewController *nextVC = [[SYCacheFileViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - 播放

- (StreamPlayer *)streamPlayer
{
    if (_streamPlayer == nil) {
        _streamPlayer = [[StreamPlayer alloc] init];
        _streamPlayer.cacheVideo = YES;
        //
        ViewController __weak *weakSelf = self;
        _streamPlayer.playComplete = ^(PLPlayerStatus status) {
            [weakSelf showMessage:status];
        };
    }
    return _streamPlayer;
}

- (void)playClick
{
//    if (self.streamPlayer) {
//        [self.streamPlayer play];
//    } else {
//        self.streamPlayer = [[StreamPlayer alloc] init];
//        self.streamPlayer.cacheVideo = YES;
//        ViewController __weak *weakSelf = self;
//        self.streamPlayer.playComplete = ^(PLPlayerStatus status) {
//            [weakSelf showMessage:status];
//        };
//
//        [self.streamPlayer playWithUrl:self.urlText view:self.playView];
//    }
    
    [self.streamPlayer playWithUrl:self.urlText view:self.playView];
}

- (void)pauseClick
{
    [self.streamPlayer pause];
}

- (void)stopClick
{
    [self.streamPlayer stop];
}

- (void)scaleClick:(UIButton *)button
{
//    button.selected = !button.selected;
//    if (self.streamPlayer) {
//        [self.streamPlayer fullScreen:button.selected];
//        self.navigationController.navigationBarHidden = button.selected;
//    }
    
    [self cacheClick];
}

#pragma mark - 截图录屏

#define widthButton (self.view.frame.size.width / 3)
CGFloat heightButton = 60.0;
- (UIButton *)shotImage
{
    if (_shotImage == nil) {
        _shotImage = [[UIButton alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - heightButton, widthButton, heightButton)];
        _shotImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _shotImage.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        [_shotImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_shotImage setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_shotImage setTitle:@"截图" forState:UIControlStateNormal];
        [_shotImage addTarget:self action:@selector(shotClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shotImage;
}

- (void)shotClick
{
    ViewController __weak *weakSelf = self;
    [self.streamPlayer screenShot:NO complete:^(UIImage *image, BOOL saveSuccess, BOOL saveAlbumSuccess) {
        NSLog(@"image = %@, state = %d-%d", image, saveSuccess, saveAlbumSuccess);
        if (weakSelf.imageView == nil) {
            weakSelf.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.width, (weakSelf.view.frame.size.height - weakSelf.view.frame.size.width - heightButton))];
            [weakSelf.view addSubview:weakSelf.imageView];
            weakSelf.imageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        weakSelf.imageView.image = image;
    }];
}

- (UIButton *)recordStartStop
{
    if (_recordStartStop == nil) {
        _recordStartStop = [[UIButton alloc] initWithFrame:CGRectMake(widthButton, self.view.frame.size.height - heightButton, widthButton, heightButton)];
        _recordStartStop.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _recordStartStop.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        [_recordStartStop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_recordStartStop setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        [_recordStartStop setTitle:@"录制视频" forState:UIControlStateNormal];
//        [_recordStartStop setTitle:@"停止录制" forState:UIControlStateSelected];
        [_recordStartStop setTitle:@"缓存大小" forState:UIControlStateNormal];
        [_recordStartStop addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordStartStop;
}

- (void)recordClick:(UIButton *)button
{
//    button.selected = !button.selected;
//    if (button.selected) {
//        [self.recorderUtil startRecorder];
//    } else {
//        [self.recorderUtil stopRecorder];
//    }
    
    NSLog(@"size: %f, image size: %f, video size: %f", self.streamPlayer.cacheSize, self.streamPlayer.cacheImageSize, self.streamPlayer.cacheVideoSize);
}

- (UIButton *)recordPauseResume
{
    if (_recordPauseResume == nil) {
        _recordPauseResume = [[UIButton alloc] initWithFrame:CGRectMake(widthButton * 2, self.view.frame.size.height - heightButton, widthButton, heightButton)];
        _recordPauseResume.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _recordPauseResume.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        [_recordPauseResume setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_recordPauseResume setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        [_recordPauseResume setTitle:@"暂停录制" forState:UIControlStateNormal];
//        [_recordPauseResume setTitle:@"继续录制" forState:UIControlStateSelected];
        [_recordPauseResume setTitle:@"删除缓存" forState:UIControlStateNormal];
        [_recordPauseResume addTarget:self action:@selector(pauseClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordPauseResume;
}

- (void)pauseClick:(UIButton *)button
{
//    button.selected = !button.selected;
//    if (button.selected) {
//        [self.recorderUtil pauseRecorder];
//    } else {
//        [self.recorderUtil resumeRecorder];
//    }
    
    [self.streamPlayer clearCacheDefault];
}

#pragma mark - 录屏

- (ScreenRecorderUtil *)recorderUtil
{
    if (_recorderUtil == nil) {
        _recorderUtil = [[ScreenRecorderUtil alloc] init];
        _recorderUtil.delegate = self;
    }
    return _recorderUtil;
}

- (void)screenRecorderFinished:(NSString *)filePath
{
    NSLog(@"filePath = %@", filePath);
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
