//
//  SYAVPlayerView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  视频播放操作、状态视图

#import <UIKit/UIKit.h>
#import "SYAVPlayerActionView.h"
#import "SYAVPlayerStatusView.h"

@interface SYAVPlayerView : UIView

/// 界面显示类型
@property (nonatomic, assign) SYAVPlayerStatusViewType viewType;

/// 视频播放交互视图
@property (nonatomic, strong) SYAVPlayerActionView *playerActionView;

/// 状态视图
@property (nonatomic, strong) SYAVPlayerStatusView *playerStatusView;

/// 播放进度
@property (nonatomic, strong) UIProgressView *progressView;

@end
