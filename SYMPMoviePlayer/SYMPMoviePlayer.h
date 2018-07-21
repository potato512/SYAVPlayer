//
//  MoviePlayerManager.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 13-12-1.
//  Copyright (c) 2013年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 导入头文件
#import <MediaPlayer/MediaPlayer.h>

@interface SYMPMoviePlayer : NSObject

/// 创建单例
+ (SYMPMoviePlayer *)shareMPMoviePlayer;

/// 播放视频（网络视频，或本地视频）
- (void)playWithFilePath:(NSString *)filePath target:(id)target;

@end

/*
 
 步骤1 添加“MediaPlayer.framework”库
 
 步骤2 导入头文件
 #import <MediaPlayer/MediaPlayer.h>

 步骤3 使用
 1、添加头文件
 #import "SYMPMoviePlayer.h"
 
 2、使用方法（全屏播放）
 [[SYMPMoviePlayer shareMPMoviePlayer] playWithFilePath:moviePath target:self];
 
 */
