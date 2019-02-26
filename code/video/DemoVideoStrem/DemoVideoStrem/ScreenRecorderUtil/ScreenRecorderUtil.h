//
//  ScreenRecorderUtil.h
//  DemoVideoStrem
//
//  Created by zhangshaoyu on 2019/2/14.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ScreenRecorderDelegate <NSObject>

- (void)screenRecorderFinished:(NSString *)filePath;

@end

@interface ScreenRecorderUtil : NSObject

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, weak) id<ScreenRecorderDelegate>delegate;

/// 开始录屏
- (void)startRecorder;
/// 停止录屏
- (void)stopRecorder;
/// 暂停录屏
- (void)pauseRecorder;
/// 继续录屏
- (void)resumeRecorder;

@end

NS_ASSUME_NONNULL_END
