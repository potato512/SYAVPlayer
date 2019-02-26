//
//  VideoUtil.m
//  DemoVideoStrem
//
//  Created by zhangshaoyu on 2019/2/26.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "VideoUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@implementation VideoUtil

- (void)cutVideoGetImageArrayWithURl:(NSURL *)urlstring Second:(float)second
{
    NSMutableArray *imageArray = [NSMutableArray array];
    
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:urlstring options:nil];//
    //获取视频时长，单位：秒
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = _videoRect.size;
    //下面两句是截取每一帧的关键
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    NSMutableArray *timeArray = [NSMutableArray array];
    
    for (int i = 1; i < second * 10 + 1 ; i++) {
        
        [timeArray addObject:[NSValue valueWithCMTime:CMTimeMake(i * 6, 60)]];
    }
    //开始截图
    [generator generateCGImagesAsynchronouslyForTimes:timeArray completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        UIImage *imageSen = [UIImage imageWithCGImage:image];
        [_imageArray addObject:imageSen];
    }];
}

@end
