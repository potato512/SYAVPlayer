//
//  AudioRecorderUtil.m
//  DemoVideoStrem
//
//  Created by zhangshaoyu on 2019/2/14.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "AudioRecorderUtil.h"
#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AudioRecorderUtil ()

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;

@end

@implementation AudioRecorderUtil

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.filePath = self.filePathTmp;
        NSLog(@"audio file: %@", self.filePath);
        
        [self addNofification];
    }
    return self;
}

- (void)dealloc
{
    [self removeFileWithFilePath:self.filePath];
    [self removeNotification];
    NSLog(@"dealloc %@", self.class);
}

#pragma mark - 方法

- (void)startAudioRecorded
{
    NSURL *fileUrl = [NSURL fileURLWithPath:self.filePath];
    NSDictionary *audioDict = @{AVSampleRateKey:[NSNumber numberWithFloat: 8000.0],
                                AVFormatIDKey:[NSNumber numberWithInt: kAudioFormatLinearPCM],
                                AVLinearPCMBitDepthKey:[NSNumber numberWithInt:16],
                                AVNumberOfChannelsKey:[NSNumber numberWithInt: 1]};
    self.recorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:audioDict error:nil];
    self.recorder.meteringEnabled = YES;
    if (self.recorder.prepareToRecord) {
        //
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        //
        [self.recorder record];
    }
}

- (void)stopAudioRecorder
{
    if (self.recorder.isRecording) {
        [self.recorder stop];
        self.recorder = nil;
        
        [self removeNotification];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecorderFinished:)]) {
            [self.delegate audioRecorderFinished:self.filePath];
        }
    }
}

- (void)pauseAudioRecorder
{
    if (self.recorder.isRecording) {
        [self.recorder pause];
    }
}

- (void)resumeAudioRecorder
{
    [self.recorder record];
}

#pragma mark - 通知

- (void)addNofification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRecorederChange:) name:@"audioRecorederChange" object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)audioRecorederChange:(NSNotification *)notification
{
    NSString *string = notification.object;
    if (string.integerValue) {
        [self.recorder record];
    } else {
        [self pauseAudioRecorder];
    }
}

#pragma mark - 文件路径

- (NSString *)filePathTmp
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [filePath stringByAppendingPathComponent:@"audioRecorder.wav"];
    [self removeFileWithFilePath:filePath];
    return filePath;
}

- (void)removeFileWithFilePath:(NSString *)filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

@end
