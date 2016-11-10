//
//  AVMoviePlayerHeader.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#ifndef AVMoviePlayerHeader_h
#define AVMoviePlayerHeader_h

#import "AVMoviePlayerTools.h"

static CGFloat const originX = 10.0;
static CGFloat const originY = 10.0;

static CGFloat const heightAction = 30.0;
static CGFloat const widthItem = 60.0;
static CGFloat const heightItem = 20.0;
static CGFloat const sizeButton = 40.0;

static CGFloat const heightStatusView = 30.0;

static NSTimeInterval const delayTime = 2.0;

static NSString *const SYAVPlayerStatus = @"status";

static NSString *const titlePlayAction = @"Play";
static NSString *const titleStopAction = @"Stop";

static NSString *const titleZoominStatus  = @"放大";
static NSString *const titleZoomoutStatus = @"缩小";



#endif /* AVMoviePlayerHeader_h */

/*
 1、自定义样式
 （1）frame大小，以及父视图
 （2）播放，或停止播放按钮
 （3）播放进度条
 （4）拖拉进度条、当前播放时间、剩余播放时间
 （5）放大，或缩小按钮
 （6）网络状态、网络加载
 2、自定义交互
 （1）手势点击：隐藏，或显示视图控件，隐藏视图控件时，只保留显示播放进度条
 （2）播放点击：开始播放，同时显示停止图标
 （3）停止点击：暂停播放，同时显示播放图标
 （4）拖拉进度条：改变播放进度，同时改变当前播放时间、剩余播放时间
 （5）放大点击：全屏播放，同时显示缩小图标
 （6）缩小点击：返回原来的播放尺寸，同时显示放大图标
 
*/