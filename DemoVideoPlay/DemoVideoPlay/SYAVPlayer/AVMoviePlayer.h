//
//  AVMoviePlayer.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/9.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "AVMoviePlayerHeader.h"


@interface AVMoviePlayer : UIView

/// 实例化
- (instancetype)initWithFrame:(CGRect)frame;

/// 视频播放地址（本地，或网络）
@property (nonatomic, copy) NSString *videoUrl;

/// 视频标题
@property (nonatomic, copy) NSString *videoTitle;

/// 全屏操作
@property (nonatomic, copy) void (^ scaleScreen)(BOOL isFullScreen);

/// 即将进入后台（暂停播放，并且保留当前播放进度）
@property (nonatomic, assign) BOOL isResignActivePlayerPause;

/// 从后台返回（重新播放，并且从上次暂停播放的进度开始播放）
@property (nonatomic, assign) BOOL isBecomeActivePlayerStart;

@end
