//
//  SYAVPlayer.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/9.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SYAVPlayerView.h"

#import "SYAVPlayerHeader.h"


@interface SYAVPlayer : UIView

/// 实例化
- (instancetype)initWithFrame:(CGRect)frame;

/// 视频播放地址（本地，或网络）
@property (nonatomic, copy) NSString *videoUrl;

/// 视频标题
@property (nonatomic, copy) NSString *videoTitle;

/// 播放播放、状态视图
@property (nonatomic, strong) SYAVPlayerView *playerView;

/// 全屏操作
@property (nonatomic, copy) void (^scaleClick)(BOOL isFullScreen);

/// 即将进入后台（暂停播放，并且保留当前播放进度）
@property (nonatomic, assign) BOOL isResignActivePlayerPause;

/// 从后台返回（重新播放，并且从上次暂停播放的进度开始播放）
@property (nonatomic, assign) BOOL isBecomeActivePlayerStart;

@end

/*
 步骤1 添加 AVFoundation.framework 库
 
 步骤2 导入头文件
 #import <AVFoundation/AVFoundation.h>
 
 步骤3 使用
 1 导入头文件
 #import "AVMoviePlayer.h"
 
 2 使用
 // 封装
 NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"movie02" ofType:@"mov"];
 // NSString *urlStr = @"http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8";
 CGRect rect = CGRectMake(10.0, 10.0, (self.view.bounds.size.width - 10.0 * 2), 200.0);
 AVMoviePlayer *player = [[AVMoviePlayer alloc] initWithFrame:rect];
 [self.view addSubview:player];
 player.videoUrl = urlStr;
 player.videoTitle = @"本地视频";
 player.playerView.playerStatusView.scaleButton.hidden = YES;
 SYAVPlayerSelfWeak;
 player.scaleClick = ^(BOOL isFullScreen){
     SYAVPlayerDelegate.allowRotation = isFullScreen;
     [SYAVPlayerWeakSelf.navigationController setNavigationBarHidden:isFullScreen animated:YES];
 };
 
*/
