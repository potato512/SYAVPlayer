//
//  AVMoviePlayerView.h
//  DemoVideoPlay
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  视频播放操作、状态视图

#import <UIKit/UIKit.h>
#import "AVMoviePlayerActionView.h"
#import "AVMoviePlayerStatusView.h"

@interface AVMoviePlayerView : UIView

/// 视频播放交互视图
@property (nonatomic, strong) AVMoviePlayerActionView *playerActionView;

/// 状态视图
@property (nonatomic, strong) AVMoviePlayerStatusView *playerStatusView;

/// 播放进度
@property (nonatomic, strong) UIProgressView *progressView;

@end
