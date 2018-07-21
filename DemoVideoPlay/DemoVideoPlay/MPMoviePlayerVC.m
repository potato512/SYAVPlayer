//
//  MPMoviePlayerViewController.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/4.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "MPMoviePlayerVC.h"
// 导入封装方法头文件
#import "SYMPMoviePlayer.h"

@interface MPMoviePlayerVC ()

@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayerController;

@end


@implementation MPMoviePlayerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"MPMovie"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"play" style:UIBarButtonItemStyleDone target:self action:@selector(startPlay:)];
}

- (void)didReceiveMemoryWarning
{
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

#pragma mark - 视频播放

- (void)movieNotification
{
    // 添加通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(moviePlayingDone)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}

// 播放事件
- (void)moviePlayingDone
{
    NSLog(@"播放完成");
    // 方法1
    // [self.moviePlayerController.view removeFromSuperview];
    // 方法2
    [self.moviePlayerController.moviePlayer stop];
    [self dismissMoviePlayerViewControllerAnimated];
    
    self.moviePlayerController = nil;
}

- (void)moviePlay:(NSString *)filePath
{
    // 方法1
    if (filePath)
    {
        NSURL *movieUrl = [NSURL fileURLWithPath:filePath];
        
        if (movieUrl)
        {
            self.moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
            MPMoviePlayerController *moviePlayer = [self.moviePlayerController moviePlayer];
            moviePlayer.movieSourceType = MPMovieSourceTypeFile;
            // 控制播放行为
            moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
            // 控制影片的尺寸
            moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
            // 准备播放SY
            [moviePlayer prepareToPlay];
            // 播放
            [moviePlayer play];
        
            // 在当前view上添加视频的视图
            // 方法1
            // [[[UIApplication sharedApplication] keyWindow] addSubview:moviePlayerView.view];
            // 方法2
            [self presentMoviePlayerViewControllerAnimated:self.moviePlayerController];
        }
    }
}

// 自定义函数
#pragma mark - custom method

// 按钮播放事件
- (void)startPlay:(UIBarButtonItem *)button
{
    // 本地文件
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    // 视频文件
//    NSString *moviePath = @"http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8";
    
    // 方法1
//    [self moviePlay:moviePath];
    
    // 方法2 封装方法
    [[SYMPMoviePlayer shareMPMoviePlayer] playWithFilePath:moviePath target:self];
    
}

@end
