//
//  SYAVPlayerController.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/27.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYAVPlayerController : NSObject

/// 播放视频（网络视频，或本地视频）
- (void)playWithFilePath:(NSString *)filePath target:(id)target;

@end

NS_ASSUME_NONNULL_END
