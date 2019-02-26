//
//  RecorderCaptureUtil.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/12.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecorderCaptureUtil : NSObject

/// 音视频合并
+ (void)mergeVideo:(NSString *)videoPath audio:(NSString *)audioPath target:(id)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
