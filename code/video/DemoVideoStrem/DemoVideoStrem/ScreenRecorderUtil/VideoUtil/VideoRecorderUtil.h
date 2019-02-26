//
//  VideoRecorderUtil.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/12.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RecorderCaptureUtil.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VideoRecorderDelegate <NSObject>

- (void)videoRecorderFinished:(NSString *)filePath;
- (void)videoRecorderFaild;

@end

@interface VideoRecorderUtil : NSObject

/// 帧率（默认10）
@property (nonatomic, assign) NSUInteger frameRate;
@property (nonatomic, assign) float spaceDate;
@property (nonatomic, strong) CALayer *captureLayer;
@property (nonatomic, weak) id<VideoRecorderDelegate> delegate;
@property (nonatomic, assign, readonly, getter=isRecording) BOOL recording;
@property (nonatomic, assign, readonly) BOOL isPause;

/// 开始录制
- (BOOL)startVideoRecorder;
/// 结束录制
- (void)stopVideoRecorder;
/// 暂停录制
- (void)pauseVideoRecorder;
/// 重新开始录制
- (void)resumeVideoRecorder;

@end

NS_ASSUME_NONNULL_END
