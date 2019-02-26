//
//  RecorderCapture.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/12.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "VideoRecorderUtil.h"
#import "CGContextCreator.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoRecorderUtil ()

@property (nonatomic, strong) AVAssetWriter *videoWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoWriterInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *avAdaptor;

@property (nonatomic, assign) BOOL recordingTmp; // 正在录制中
@property (nonatomic, assign) BOOL isPauseTmp;
@property (nonatomic, assign) BOOL writing; // 正在将帧写入文件
@property (nonatomic, strong) NSDate *startedAt; // 录制的开始时间
@property (nonatomic, assign) CGContextRef context; // 绘制layer的context
@property (nonatomic, strong) NSTimer *timer; // 按帧率写屏的定时器

@property (nonatomic, copy) NSString *filePath;

@end

@implementation VideoRecorderUtil

//+ (VideoRecorderUtil *)sharedRecorder
//{
//    static VideoRecorderUtil *recorder;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        recorder = [[VideoRecorderUtil alloc] init];
//    });
//    return recorder;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frameRate = 10;
        self.recordingTmp = NO;
        self.isPauseTmp = NO;
        
        self.filePath = self.filePathTmp;
        NSLog(@"video file: %@", self.filePath);
    }
    return self;
}

- (void)dealloc
{
    [self stopTimer];
    [self removeFileWithFilePath:self.filePath];
    
    NSLog(@"dealloc %@", self.class);
}

#pragma mark -

- (BOOL)startVideoRecorder
{
    BOOL result = NO;
    if (!self.recordingTmp) {
        result = [self startWriter];
        if (result) {
            self.startedAt = [NSDate date];
            self.spaceDate = 0;
            self.recordingTmp = YES;
            self.writing = YES;
            
            [self startTimer];
        }
    }
    return result;
}

- (void)pauseVideoRecorder
{
    @synchronized (self) {
        if (self.recordingTmp) {
            self.isPauseTmp = YES;
            self.recordingTmp = NO;
        }
    }
}

- (void)resumeVideoRecorder
{
    @synchronized (self) {
        if (self.isPause) {
            self.isPauseTmp = NO;
            self.recordingTmp = YES;
        }
    }
}

- (void)stopVideoRecorder
{
    self.isPauseTmp = NO;
    self.recordingTmp = NO;
    [self stopTimer];

    [self stopWriter];
}

#pragma mark - record

- (BOOL)startWriter
{
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        BOOL result = [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:&error];
        return result;
    }
    
    CGSize sizeTmp = UIScreen.mainScreen.bounds.size;
    float scaleTmp = UIScreen.mainScreen.scale;
    CGSize size = CGSizeMake(sizeTmp.width * scaleTmp, sizeTmp.height * scaleTmp);
    
    // 视频尺寸*比率，10.1相当于AVCaptureSessionPresetHigh，数值越大，显示越精细
    NSDictionary *compressDict = @{AVVideoAverageBitRateKey: [NSNumber numberWithDouble:size.width*size.height]};
    NSDictionary *settingDict = @{AVVideoCodecKey: AVVideoCodecH264,
                                  AVVideoWidthKey: [NSNumber numberWithInt:size.width],
                                  AVVideoHeightKey: [NSNumber numberWithInt:size.height],
                                  AVVideoCompressionPropertiesKey: compressDict};
    self.videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settingDict];
    self.videoWriterInput.expectsMediaDataInRealTime = YES;
    //
    NSMutableDictionary *bufferDict = [[NSMutableDictionary alloc] init];
    [bufferDict setObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
    [bufferDict setObject:[NSNumber numberWithUnsignedInt:size.width] forKey:(NSString *)kCVPixelBufferWidthKey];
    [bufferDict setObject:[NSNumber numberWithUnsignedInt:size.height] forKey:(NSString *)kCVPixelBufferHeightKey];
    [bufferDict setObject:@(1) forKey:(NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey];
    //
    self.avAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.videoWriterInput sourcePixelBufferAttributes:bufferDict];
    //
    NSURL *fileUrl = [NSURL fileURLWithPath:self.filePath];
    self.videoWriter = [[AVAssetWriter alloc] initWithURL:fileUrl fileType:AVFileTypeQuickTimeMovie error:&error];
    [self.videoWriter addInput:self.videoWriterInput];
    [self.videoWriter startWriting];
    [self.videoWriter startSessionAtSourceTime:CMTimeMake(0, 1000)];
    
    if (self.context == NULL) {
        UIGraphicsBeginImageContextWithOptions(UIApplication.sharedApplication.delegate.window.frame.size, YES, 0);
        self.context = UIGraphicsGetCurrentContext();
    }
    
    if (self.context == NULL) {
        return NO;
    }
    return YES;
}

- (void)stopWriter
{
    [self finishWriter];
    
    if (self.avAdaptor) {
        self.avAdaptor = nil;
    }
    if (self.videoWriterInput) {
        self.videoWriterInput = nil;
    }
    if (self.videoWriter) {
        self.videoWriter = nil;
    }
    if (self.startedAt) {
        self.startedAt = nil;
    }
}

- (void)finishWriter
{
    [self.videoWriterInput markAsFinished];
    if (@available(iOS 10.3, *)) {
        VideoRecorderUtil __weak *weakSelf = self;
        AVAssetWriterStatus status = self.videoWriter.status;
        [self.videoWriter finishWritingWithCompletionHandler:^{
            if (AVContentKeyRequestStatusFailed == status) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoRecorderFaild)]) {
                    [weakSelf.delegate videoRecorderFaild];
                }
            } else {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoRecorderFinished:)]) {
                    [weakSelf.delegate videoRecorderFinished:weakSelf.filePath];
                }
            }
        }];
    } else {
        // Fallback on earlier versions
        if (!self.videoWriter.finishWriting) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoRecorderFaild)]) {
                [self.delegate videoRecorderFaild];
            }
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoRecorderFinished:)]) {
            [self.delegate videoRecorderFinished:self.filePath];
        }
    }
}

- (BOOL)is64bit
{
#if defined(__LP64__) && __LP64__
    NSLog(@"设备是64位的");
    return YES;
#else
    NSLog(@"设备是32位的");
    return NO;
#endif
}

#pragma mark - 文件路径

- (NSString *)filePathTmp
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [filePath stringByAppendingPathComponent:@"videoRecorder.mp4"];
    [self removeFileWithFilePath:filePath];
    return filePath;
}

- (void)removeFileWithFilePath:(NSString *)filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

#pragma mark - timer

- (void)startTimer
{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / self.frameRate target:self selector:@selector(writeFrame) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)writeFrame
{
    if (self.isPauseTmp) {
        self.spaceDate = self.spaceDate + 1.0 / self.frameRate;
        return;
    }
    
    if (!self.writing) {
        [self performSelectorInBackground:@selector(readFrame) withObject:nil];
    }
}

- (void)readFrame
{
    if (!self.writing) {
        self.writing = YES;
        
        size_t width = CGBitmapContextGetWidth(self.context);
        size_t height = CGBitmapContextGetHeight(self.context);
        @try {
            CGContextClearRect(self.context, CGRectMake(0.0, 0.0, width, height));
            [UIApplication.sharedApplication.delegate.window.layer renderInContext:self.context];
            UIApplication.sharedApplication.delegate.window.layer.contents = nil;
            CGImageRef imageRef = CGBitmapContextCreateImage(self.context);
            if (self.recordingTmp) {
                float millisElapsed = [[NSDate date] timeIntervalSinceDate:self.startedAt] * 1000.0 - self.spaceDate * 1000.0;
                [self videoFrameWithTime:CMTimeMake((int)millisElapsed, 1000) image:imageRef];
            }
            CGImageRelease(imageRef);
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        self.writing = NO;
    }
}

- (void)videoFrameWithTime:(CMTime)time image:(CGImageRef)image
{
    if (self.videoWriterInput.isReadyForMoreMediaData) {
        @synchronized (self) {
            CGImageRef imageRef = CGImageCreateCopy(image);
            CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
            CVPixelBufferRef bufferRef = NULL;
            int status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, self.avAdaptor.pixelBufferPool, &bufferRef);
            CVPixelBufferLockBaseAddress(bufferRef, 0);
            uint8_t *destPixels = CVPixelBufferGetBaseAddress(bufferRef);
            CFDataGetBytes(dataRef, CFRangeMake(0, CFDataGetLength(dataRef)), destPixels);
            if (status == 0) {
                BOOL result = [self.avAdaptor appendPixelBuffer:bufferRef withPresentationTime:time];
                if (!result) {
                    NSLog(@"Warning:  Unable to write buffer to video");
                }
            }
            
            CVPixelBufferUnlockBaseAddress(bufferRef, 0);
            CVPixelBufferRelease(bufferRef);
            CFRelease(dataRef);
            CGImageRelease(imageRef);
        }
    }
}

#pragma mark - getter

- (BOOL)isRecording
{
    return self.recordingTmp;
}

- (BOOL)isPause
{
    return self.isPauseTmp;
}

@end
