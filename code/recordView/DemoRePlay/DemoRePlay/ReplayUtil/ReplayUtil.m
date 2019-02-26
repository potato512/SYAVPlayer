//
//  ReplayUtil.m
//  DemoRePlay
//
//  Created by zhangshaoyu on 2019/1/8.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "ReplayUtil.h"

@interface ReplayUtil () <RPPreviewViewControllerDelegate>

@property (nonatomic, strong) UIViewController *controller;

@end

@implementation ReplayUtil

- (void)startRecorder:(void (^)(BOOL isSuccess))complete
{
    if ([RPScreenRecorder sharedRecorder].isAvailable) {
        if ([RPScreenRecorder sharedRecorder].isRecording) {
            NSLog(@"正在录制...");
            if (complete) {
                complete(YES);
            }
        } else {
            if (@available(iOS 10.0, *)) {
                [[RPScreenRecorder sharedRecorder] startRecordingWithHandler:^(NSError * _Nullable error) {
                    [RPScreenRecorder sharedRecorder].microphoneEnabled = YES;
                    if (complete) {
                        complete(error ? NO : YES);
                    }
                }];
            } else {
                // Fallback on earlier versions
                [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
                    if (complete) {
                        complete(error ? NO : YES);
                    }
                }];
            }
//            if (@available(iOS 10.0, *)) {
//                [RPScreenRecorder sharedRecorder].cameraEnabled = YES;
//            } else {
//                // Fallback on earlier versions
//            }
//            [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
//                if (complete) {
//                    complete(error ? NO : YES);
//                }
//            }];
        }
    } else {
        NSLog(@"设备不支持录屏功能");
        if (complete) {
            complete(NO);
        }
    }
}

- (void)stopRecorderWithTarget:(id)target complete:(void (^)(RPPreviewViewController *previewViewController, NSError *error))complete
{
    if (target == nil || ![target isKindOfClass:[UIViewController class]]) {
        NSLog(@"target应为UIViewController类型");
        return;
    }
    self.controller = target;
    
    [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        
        if (self.controller && previewViewController) {
            previewViewController.previewControllerDelegate = self;
            [self.controller presentViewController:previewViewController animated:YES completion:NULL];
        }
        if (complete) {
            complete(previewViewController, error);
        }
    }];
}


// 回放预览界面的代理方法
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    // 用户操作完成后，返回之前的界面
    [previewController dismissViewControllerAnimated:YES completion:nil];
}

@end
