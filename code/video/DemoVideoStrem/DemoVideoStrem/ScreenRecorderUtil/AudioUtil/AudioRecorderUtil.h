//
//  AudioRecorderUtil.h
//  DemoVideoStrem
//
//  Created by zhangshaoyu on 2019/2/14.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioRecorderDelegate <NSObject>

- (void)audioRecorderFinished:(NSString *)filePath;

@end

@interface AudioRecorderUtil : NSObject

@property (nonatomic, weak) id<AudioRecorderDelegate>delegate;

/// 开始录制
- (void)startAudioRecorded;
/// 结束录制
- (void)stopAudioRecorder;
/// 暂停录制
- (void)pauseAudioRecorder;
/// 继续录制
- (void)resumeAudioRecorder;

@end

NS_ASSUME_NONNULL_END
