//
//  SYAVPlayerController.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/27.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "SYAVPlayerController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@implementation SYAVPlayerController

/// 播放视频（网络视频，或本地视频）
- (void)playWithFilePath:(NSString *)filePath target:(id)target;
{
    if (filePath == nil || filePath.length < 0 || target == nil) {
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    if ([filePath hasPrefix:@"https://"] || [filePath hasPrefix:@"http://"]) {
        url = [NSURL URLWithString:filePath];
    }
    
    AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
    playerController.showsPlaybackControls = YES;
    playerController.player = [[AVPlayer alloc] initWithURL:url];
    [playerController.player play];
    [target presentViewController:playerController animated:YES completion:nil];
}

@end
