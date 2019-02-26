//
//  ScreenRecorderUtil.m
//  DemoVideoStrem
//
//  Created by zhangshaoyu on 2019/2/14.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "ScreenRecorderUtil.h"
#import "AudioUtil/AudioRecorderUtil.h"
#import "VideoUtil/VideoRecorderUtil.h"

@interface ScreenRecorderUtil () <VideoRecorderDelegate, AudioRecorderDelegate>

@property (nonatomic, strong) AudioRecorderUtil *audioRecorder;
@property (nonatomic, strong) VideoRecorderUtil *videoRecorder;

@property (nonatomic, strong) NSString *filePathVideo;
@property (nonatomic, strong) NSString *filePathAudio;

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPausing;

@end

@implementation ScreenRecorderUtil

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long int date = (long long int)time;
        NSString *fileName = [NSString stringWithFormat:@"%lldScreenRecorder.mp4", date];
        self.filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/ScreenRecorder/%@", fileName]];
        NSLog(@"video file: %@", self.filePath);
    }
    return self;
}

- (void)dealloc
{
    [self removeNotification];
    NSLog(@"dealloc %@", self.class);
}

#pragma mark -

/// 开始录屏
- (void)startRecorder
{
    if (self.isRecording) {
        return;
    }
    
    self.isRecording = YES;
    
    [self.audioRecorder startAudioRecorded];
    [self.videoRecorder startVideoRecorder];
}

/// 停止录屏
- (void)stopRecorder
{
    if (self.isRecording) {
        self.isRecording = NO;
        self.isPausing = NO;
        
        [self.videoRecorder stopVideoRecorder];
        [self.audioRecorder stopAudioRecorder];
    }
}

/// 暂停录屏
- (void)pauseRecorder
{
    if (self.isRecording) {
        self.isRecording = NO;
        self.isPausing = YES;
        
        [self.videoRecorder pauseVideoRecorder];
        [self.audioRecorder pauseAudioRecorder];
    }
}

/// 继续录屏
- (void)resumeRecorder
{
    if (self.isPausing) {
        self.isPausing = YES;
        
        [self.videoRecorder resumeVideoRecorder];
        [self.audioRecorder resumeAudioRecorder];
    }
}

#pragma mark - 通知

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)removeNotification
{
    
}

- (void)enterBackground:(NSNotification *)notificaton
{
    if (self.isRecording) {
        [self stopRecorder];
    }
}

#pragma mark - delegate

- (void)audioRecorderFinished:(NSString *)filePath
{
    self.filePathAudio = filePath;
    [self finishRecorder];
}

- (void)videoRecorderFinished:(NSString *)filePath
{
    self.filePathVideo = filePath;
    [self finishRecorder];
}

- (void)videoRecorderFaild
{
    
}

- (void)finishRecorder
{
    if ((self.filePathVideo && self.filePathVideo.length > 0) && (self.filePathAudio && self.filePathAudio.length > 0)) {
        [RecorderCaptureUtil mergeVideo:self.filePathVideo audio:self.filePathAudio target:self selector:@selector(mergeComplete:WithError:)];
    }
}

- (void)mergeComplete:(NSString *)videoPath WithError:(NSError *)error
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtPath:videoPath toPath:self.filePath error:&error];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:videoPath error:&error];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(screenRecorderFinished:)]) {
        [self.delegate screenRecorderFinished:self.filePath];
    }
}

#pragma mark - getter

- (VideoRecorderUtil *)videoRecorder
{
    if (_videoRecorder == nil) {
        _videoRecorder = [[VideoRecorderUtil alloc] init];
        _videoRecorder.delegate = self;
        _videoRecorder.frameRate = 35;
    }
    return _videoRecorder;
}

- (AudioRecorderUtil *)audioRecorder
{
    if (_audioRecorder == nil) {
        _audioRecorder = [[AudioRecorderUtil alloc] init];
        _audioRecorder.delegate = self;
    }
    return _audioRecorder;
}

@end
