//
//  RecorderCaptureUtil.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/12.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "RecorderCaptureUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@implementation RecorderCaptureUtil

+ (void)mergeVideo:(NSString *)videoPath audio:(NSString *)audioPath target:(id)target selector:(SEL)selector
{
    if (videoPath == nil || videoPath.length <= 0) {
        return;
    }
    
    if (audioPath == nil || audioPath.length <= 0) {
        return;
    }
    
    // 视频文件
    NSURL *videoUrl = [NSURL fileURLWithPath:videoPath];
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    // 音频文件
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioUrl options:nil];
    
    // 混合
    AVMutableComposition *composition = [AVMutableComposition composition];
    // 混合视频
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    // 混合音频
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    //
    
    NSString *exportName = @"export.mov";
    NSString *exportPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:exportName];
    if ([NSFileManager.defaultManager fileExistsAtPath:exportPath]) {
        [NSFileManager.defaultManager removeItemAtPath:exportPath error:nil];
    }
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetPassthrough];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
    exportSession.outputFileType = @"com.apple.quicktime-movie";
    exportSession.outputURL = exportUrl;
    exportSession.shouldOptimizeForNetworkUse = YES;
    NSLog(@"path = %@, type = %@", exportSession.outputFileType);
    //
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (target && [target respondsToSelector:selector]) {
            [target performSelector:selector withObject:exportPath];
        }
    }];
}

@end
