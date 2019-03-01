//
//  SYLivePlayer.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/3/1.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "SYLivePlayer.h"

@interface SYLivePlayer () <PLPlayerDelegate>

@property (nonatomic, assign) BOOL isPause;

@property (nonatomic, strong) PLPlayerOption *playOption;
@property (nonatomic, strong) PLPlayer *player;

@property (nonatomic, copy) void (^imageShot)(UIImage *image, BOOL saveSuccess, BOOL saveAlbumSuccess);
@property (nonatomic, assign) BOOL saveSuccess;

@property (nonatomic, strong) UIView *view;

@end

@implementation SYLivePlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 视频缓存目录
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *document = [paths objectAtIndex:0];
        NSString *videoPath = [document stringByAppendingPathComponent:@"/PlayerVideo"];
        NSString *imagePath = [document stringByAppendingPathComponent:@"/PlayerImage"];
        self.cacheVideoPath = videoPath;
        self.cacheImagePath = imagePath;
    }
    return self;
}

- (void)playWithUrl:(NSString *)url view:(UIView *)view
{
    if (url == nil || url.length <= 0 || ![self isValidUrl:url]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"url无效" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil] show];
        return;
    }
    
    if (view == nil || ![view isKindOfClass:[UIView class]]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"view应为UIView" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil] show];
        return;
    }
    
    //
    NSURL *streamUrl = [NSURL URLWithString:url];
    self.view = view;
    
    //
    if (self.player) {
        if (self.isPause) {
            [self play];
            return;
        } else {
            if (!self.player.isPlaying) {
                if ([streamUrl isEqual:self.player.URL]) {
                    [self.player play];
                    return;
                }
            }
        }
    }
    
    //
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    //
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    NSString *urlString = url.lowercaseString;
    if ([urlString hasSuffix:@"mp4"]) {
        format = kPLPLAY_FORMAT_MP4;
    } else if ([urlString hasPrefix:@"rtmp:"]) {
        format = kPLPLAY_FORMAT_FLV;
    } else if ([urlString hasSuffix:@".mp3"]) {
        format = kPLPLAY_FORMAT_MP3;
    } else if ([urlString hasSuffix:@".m3u8"]) {
        format = kPLPLAY_FORMAT_M3U8;
    }
    [self.playOption setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
    // 初始化 PLPlayer
    self.player = [PLPlayer playerWithURL:streamUrl option:self.playOption];
    //
    [self.player setBufferingEnabled:NO];
    //
    self.player.delegate = self; // 设定代理 (optional)
    self.player.delegateQueue = dispatch_get_main_queue();
    // 获取视频输出视图并添加为到当前 UIView 对象的 Subview
    if (self.view && self.player.playerView.superview == nil) {
        self.player.playerView.frame = self.view.bounds;
        self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.player.playerView];
        [self.view sendSubviewToBack:self.player.playerView];
    }
    
    [self.player play];
}

- (BOOL)isValidUrl:(NSString *)url
{
    NSInteger flag = 0;
    if ([url hasPrefix:@"http://"]) {
        flag += 1;
    }
    if ([url hasPrefix:@"https://"]) {
        flag += 1;
    }
    if ([url hasPrefix:@"rtmp://"]) {
        flag += 1;
    }
    if (flag != 0) {
        return YES;
    }
    return NO;
}

#pragma mark - getter

- (PLPlayerOption *)playOption
{
    if (_playOption == nil) {
        //
        _playOption = [PLPlayerOption defaultOption];
        [_playOption setOptionValue:@(12) forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
        [_playOption setOptionValue:@(2000) forKey:PLPlayerOptionKeyMaxL1BufferDuration];
        [_playOption setOptionValue:@(1000) forKey:PLPlayerOptionKeyMaxL2BufferDuration];
        [_playOption setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
        [_playOption setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
        // 缓存功能（通过cacheVideo属性设置）
        //        [_playOption setOptionValue:self.cacheVideoPath forKey:PLPlayerOptionKeyVideoCacheFolderPath];
        //        [_playOption setOptionValue:@"mp4" forKey:PLPlayerOptionKeyVideoCacheExtensionName];
    }
    return _playOption;
}

#pragma mark - 操作

- (void)play
{
    if (self.player) {
        self.isPause = NO;
        [self.player resume];
    }
}

- (void)pause
{
    if (self.player) {
        if (self.player.isPlaying) {
            [self.player pause];
            self.isPause = YES;
        }
    }
}

- (void)stop
{
    if (self.player) {
        if (self.player.isPlaying) {
            self.isPause = NO;
            [self.player stop];
        }
    }
}

- (void)screenShot:(BOOL)isSaveAlbum complete:(void (^)(UIImage *image, BOOL saveSuccess, BOOL saveAlbumSuccess))complete
{
    if (self.player) {
        UIView *view = self.player.playerView;
        CGRect rect = view.frame;
        CGSize size = rect.size;
        //
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //
            UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
            [view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            //
            if (image) {
                if (![[NSFileManager defaultManager] fileExistsAtPath:self.cacheImagePath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:self.cacheImagePath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                NSString *imagePath = [self.cacheImagePath stringByAppendingPathComponent:self.imageName];
                NSData *imageData = UIImagePNGRepresentation(image);
                BOOL result = [imageData writeToFile:imagePath atomically:YES];
                NSLog(@"截图保存：%@", (result ? @"成功" : @"失败"));
                self.saveSuccess = result;
                
                if (isSaveAlbum) {
                    self.imageShot = [complete copy];
                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (complete) {
                            complete(image, result, NO);
                        }
                    });
                }
            }
        });
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.imageShot) {
            self.imageShot(image, self.saveSuccess, (error ? NO : YES));
        }
    });
}

- (NSString *)imageName
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *result = [formatter stringFromDate:date];
    result = [NSString stringWithFormat:@"%@.png", result];
    return result;
}

- (void)fullScreen:(BOOL)isFull
{
    if (self.player.playerView.superview) {
        if (isFull) {
            [UIView animateWithDuration:0.3 animations:^{
                //                NSLog(@"max 1 %@", self.player.playerView);
                //                UIView *fullView = [UIApplication sharedApplication].delegate.window;
                //                [fullView addSubview:self.player.playerView];
                //                self.player.playerView.frame = CGRectMake(0.0, 0.0, fullView.frame.size.height, fullView.frame.size.width);
                //                NSLog(@"max 2 %@", self.player.playerView);
                //
                //                self.player.playerView.transform = CGAffineTransformMakeRotation(M_PI / 2);
                //                //
                //                NSLog(@"max 1 %@", self.player.playerView);
                //                UIView *fullView = [UIApplication sharedApplication].delegate.window;
                //                fullView.backgroundColor = [UIColor redColor];
                //                [fullView addSubview:self.player.playerView];
                //                self.player.playerView.frame = CGRectMake(0.0, 0.0, fullView.frame.size.height, fullView.frame.size.width);
                //                self.player.playerView.center = fullView.center;
                //                NSLog(@"max 2 %@", self.player.playerView);
            } completion:^(BOOL finished) {
                //                NSLog(@"max 1 %@", self.player.playerView);
                //                UIView *fullView = [UIApplication sharedApplication].delegate.window;
                //                [fullView addSubview:self.player.playerView];
                //                self.player.playerView.frame = CGRectMake(0.0, 0.0, fullView.frame.size.height, fullView.frame.size.width);
                //                NSLog(@"max 2 %@", self.player.playerView);
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                //                NSLog(@"min 1 %@", self.player.playerView);
                //                self.player.playerView.frame = self.view.bounds;
                //                [self.view addSubview:self.player.playerView];
                //                [self.view sendSubviewToBack:self.player.playerView];
                //                NSLog(@"min 2 %@", self.player.playerView);
                //
                //                self.player.playerView.transform = CGAffineTransformMakeRotation(M_PI * 2);
                //                //
                //                NSLog(@"min 1 %@", self.player.playerView);
                //                self.player.playerView.frame = self.view.bounds;
                //                [self.view addSubview:self.player.playerView];
                //                [self.view sendSubviewToBack:self.player.playerView];
                //                self.player.playerView.center = self.view.center;
                //                NSLog(@"min 2 %@", self.player.playerView);
            } completion:^(BOOL finished) {
                //                NSLog(@"min 1 %@", self.player.playerView);
                //                self.player.playerView.frame = self.view.bounds;
                //                [self.view addSubview:self.player.playerView];
                //                [self.view sendSubviewToBack:self.player.playerView];
                //                NSLog(@"min 2 %@", self.player.playerView);
            }];
        }
    }
}

- (void)enterFullscreen {
    
//    if (self.isFullScreen) {
//        return;
//    }
//    self.oldFrame = self.frame;
//    self.parentV = self.superview;
//    self.fullScrrenBtn.hidden = YES;
//
//    CGRect rectInWindow = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
//    [self removeFromSuperview];
//    self.frame = rectInWindow;
//
//
//
//    NSLog(@"self1:%@",self);
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//
//
//    [UIView animateWithDuration:0.3 animations:^{
//
//        self.transform = CGAffineTransformMakeRotation(M_PI_2);
//        self.bounds = CGRectMake(0, 0, CGRectGetHeight(self.superview.bounds), CGRectGetWidth(self.superview.bounds));
//        self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
//        [self.player refreshFrame:self.bounds];
//
//    } completion:^(BOOL finished) {
//        self.isFullScreen = YES;
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
//        NSLog(@"self2:%@",self);
//        self.ctrView.frame = CGRectMake(0, self.getVWidth-kCtrViewHeight, self.getVHeight,kCtrViewHeight);
//        [self showSubV];
//
//    }];
//    [self tap];
}

- (void)exitFullscreen {
    
//    if (!self.isFullScreen) {
//        return;
//    }
//
//    [self.fullScrrenBtn setHidden:NO];
//
//    [self.ctrView hidden];
//    CGRect frame = [self.superview convertRect:self.oldFrame toView:[UIApplication sharedApplication].keyWindow];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.transform = CGAffineTransformIdentity;
//        self.frame = frame;
//        [self.player setPlayViewHidden:YES];
//    } completion:^(BOOL finished) {
//
//        [self removeFromSuperview];
//        self.frame = self.oldFrame;
//
//        [self.player refreshFrame:self.bounds];
//        [self.player setPlayViewHidden:NO];
//
//        //        if (self.parentV.subviews.count>0) {
//        //          [self.parentV insertSubview:self atIndex:self.parentV.subviews.count-1];
//        //        }else
//        //        {
//        [self.parentV addSubview:self];
//        //        }
//
//        self.isFullScreen = NO;
//        self.headView.hidden = NO;
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//
//    }];
    
}

#pragma mark 缓存

- (CGFloat)cacheSize
{
    return (self.cacheVideoSize + self.cacheImageSize);
}

- (CGFloat)cacheImageSize
{
    CGFloat size = 0.0;
    if (!self.player.isPlaying) {
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:self.cacheImagePath];
        NSLog(@"files :%ld",[files count]);
        for (NSString *file in files) {
            NSString *path = [self.cacheImagePath stringByAppendingPathComponent:file];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:self.cacheImagePath error:nil];
                size += [dict fileSize];
            }
        }
    }
    return size;
}

- (CGFloat)cacheVideoSize
{
    CGFloat size = 0.0;
    if (!self.player.isPlaying) {
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:self.cacheVideoPath];
        NSLog(@"files :%ld",[files count]);
        for (NSString *file in files) {
            NSString *path = [self.cacheVideoPath stringByAppendingPathComponent:file];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:self.cacheVideoPath error:nil];
                size += [dict fileSize];
            }
        }
    }
    return size;
}

/// 清除全部缓存
- (void)clearCacheDefault
{
    [self clearCacheVideo];
    [self clearCacheImage];
}

/// 清除视频缓存
- (void)clearCacheVideo
{
    [self clearCacheWithPath:self.cacheVideoPath];
}

/// 清除图片缓存
- (void)clearCacheImage
{
    [self clearCacheWithPath:self.cacheImagePath];
}

- (void)clearCacheWithPath:(NSString *)filePath
{
    if (!self.player.isPlaying) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:filePath];
            NSLog(@"files :%ld",[files count]);
            for (NSString *file in files) {
                NSError *error;
                NSString *path = [filePath stringByAppendingPathComponent:file];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
            [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
        });
    }
}

- (void)clearCacheSuccess
{
    NSLog(@"清理成功");
}

#pragma mark - delegate

// 实现 <PLPlayerDelegate> 来控制流状态的变更
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
    // 除了 Error 状态，其他状态都会回调这个方法
    // 开始播放，当连接成功后，将收到第一个 PLPlayerStatusCaching 状态
    // 第一帧渲染后，将收到第一个 PLPlayerStatusPlaying 状态
    // 播放过程中出现卡顿时，将收到 PLPlayerStatusCaching 状态
    // 卡顿结束后，将收到 PLPlayerStatusPlaying 状态
    NSLog(@"1 state = %@", @(state));
    
    if (self.playComplete) {
        self.playComplete(state);
    }
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    // 当发生错误，停止播放时，会回调这个方法
    NSLog(@"2 error = %@", error);
}

- (void)player:(nonnull PLPlayer *)player codecError:(nonnull NSError *)error {
    // 当解码器发生错误时，会回调这个方法
    // 当 videotoolbox 硬解初始化或解码出错时
    // error.code 值为 PLPlayerErrorHWCodecInitFailed/PLPlayerErrorHWDecodeFailed
    // 播发器也将自动切换成软解，继续播放
    NSLog(@"3 error = %@", error);
}

- (void)playerWillBeginBackgroundTask:(PLPlayer *)player {
    NSLog(@"player will begin background task");
}

- (void)playerWillEndBackgroundTask:(PLPlayer *)player {
    NSLog(@"player will end background task");
}

- (void)player:(PLPlayer *)player width:(int)width height:(int)height {
    NSLog(@"width: %d  height:%d",width,height);
}

- (void)player:(PLPlayer *)player seekToCompleted:(BOOL)isCompleted{
    NSLog(@"player seek to completed");
}

#pragma mark - setter

- (void)setCacheVideo:(BOOL)cacheVideo
{
    _cacheVideo = cacheVideo;
    if (_cacheVideo) {
        if ([self.playOption optionValueForKey:PLPlayerOptionKeyVideoCacheFolderPath]) {
            [self.playOption setOptionValue:nil forKey:PLPlayerOptionKeyVideoCacheFolderPath];
            // [self.playOption setOptionValue:nil forKey:PLPlayerOptionKeyVideoCacheExtensionName];
        } else {
            [self.playOption setOptionValue:self.cacheVideoPath forKey:PLPlayerOptionKeyVideoCacheFolderPath];
            // [self.playOption setOptionValue:@"mp4" forKey:PLPlayerOptionKeyVideoCacheExtensionName];
        }
    } else {
        [self.playOption setOptionValue:nil forKey:PLPlayerOptionKeyVideoCacheFolderPath];
    }
}

@end
