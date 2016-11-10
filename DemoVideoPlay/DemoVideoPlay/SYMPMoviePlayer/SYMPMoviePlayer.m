//
//  MoviePlayerManager.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 13-12-1.
//  Copyright (c) 2013年 zhangshaoyu. All rights reserved.
//

#import "SYMPMoviePlayer.h"

@interface SYMPMoviePlayer ()

@property (nonatomic, retain) MPMoviePlayerViewController *playerViewController;
@property (nonatomic, strong) MPMoviePlayerController *playerController;
@property (nonatomic, strong) NSURL *playerUrl;
@property (nonatomic, strong) UIViewController *controller;

@end

@implementation SYMPMoviePlayer

#pragma mark - 生命周期

// 初始化
- (id)init
{
    self = [super init];
    if (self)
    {

    }
    
    return self;
}

// 内存管理
- (void)dealloc
{
    NSLog(@"dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.playerController stop];
}

#pragma mark - 单例

/// 创建单例
+ (SYMPMoviePlayer *)shareMPMoviePlayer
{
    static SYMPMoviePlayer *sharedManager;
    if (sharedManager == nil)
    {
        @synchronized (self) {
            sharedManager = [[self alloc] init];
            assert(sharedManager != nil);
        }
    }
    return sharedManager;
}

#pragma mark - 通知

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}

- (void)movieFinishedCallback:(NSNotification *)aNotification
{
    NSLog(@"movieFinishedCallback");


//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect rect = self.playerViewController.view.frame;
//        rect.origin.y = [UIScreen mainScreen].bounds.size.height;
//        self.playerViewController.view.frame = rect;
//    } completion:^(BOOL finished) {
//        [self.playerViewController.view removeFromSuperview];
//    }];

    
    [self.playerController stop];
    [self.controller dismissMoviePlayerViewControllerAnimated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 视频播放

/// 播放视频（网络地址，或本地路径，或本地文件名称）
- (void)playWithFilePath:(NSString *)filePath target:(id)target
{
    if (!filePath || 0 >= filePath.length || !target)
    {
        return;
    }

    self.controller = target;
    
    if ([filePath hasPrefix:@"https://"] || [filePath hasPrefix:@"http://"])
    {
        // 是否是网络文件
        self.playerUrl = [NSURL URLWithString:filePath];
        
        self.playerController.movieSourceType = MPMovieSourceTypeStreaming;
    }
    else
    {
        // 是否存在本地视频文件
        NSString *fileName = [self fileNameWithFile:filePath];
        NSString *fileType = [self fileTypeWithFile:filePath];
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            self.playerUrl = [NSURL fileURLWithPath:filePath];
            
            self.playerController.movieSourceType = MPMovieSourceTypeFile;
        }
    }
    
    if (self.playerUrl)
    {
//        [self.playerController prepareToPlay];
//        [self.playerController play];
//        [self addNotification];
//        // 在当前view上添加视频的视图
//        __block CGRect rect = self.playerViewController.view.frame;
//        rect.origin.y = [UIScreen mainScreen].bounds.size.height;
//        self.playerViewController.view.frame = rect;
//        [[[UIApplication sharedApplication] keyWindow] addSubview:self.playerViewController.view];
//        [UIView animateWithDuration:0.3 animations:^{
//            rect = self.playerViewController.view.frame;
//            rect.origin.y = 0.0;
//            self.playerViewController.view.frame = rect;
//        } completion:^(BOOL finished) {
//            
//        }];

        
        [self addNotification];
        [self.controller presentMoviePlayerViewControllerAnimated:self.playerViewController];

        [self.playerController prepareToPlay];
        [self.playerController play];
    }
}

#pragma mark - 获取文件名称、文件类型

- (NSString *)fileNameWithFile:(NSString *)file
{
    NSString *name = file;
    
    if (file && 0 < file.length)
    {
        NSRange range = [name rangeOfString:@"/" options:NSBackwardsSearch];
        if (range.location != NSNotFound)
        {
            name = [file substringFromIndex:(range.location + range.length)];
        }
    }
    
    NSRange range = [name rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound)
    {
        name = [name substringToIndex:range.location];
    }
    
    return name;
}

- (NSString *)fileTypeWithFile:(NSString *)file
{
    if (file && 0 < file.length)
    {
        NSRange range = [file rangeOfString:@"." options:NSBackwardsSearch];
        if (range.location != NSNotFound)
        {
            NSString *type = [file substringFromIndex:range.location + range.length];
            return type;
        }
        return nil;
    }
    return nil;
}

#pragma mark - getter

- (MPMoviePlayerViewController *)playerViewController
{
    if (_playerViewController == nil)
    {
        _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.playerUrl];
    }
    
    return _playerViewController;
}

- (MPMoviePlayerController *)playerController
{
    if (_playerController == nil)
    {
        _playerController = self.playerViewController.moviePlayer;
   
        // 控制播放行为
        _playerController.controlStyle = MPMovieControlStyleFullscreen;
        // 控制影片的尺寸
        _playerController.scalingMode = MPMovieScalingModeAspectFit;
        // 自动播放
        _playerController.shouldAutoplay = YES;
    }
    
    return _playerController;
}

@end
