//
//  SYLivePlayer.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/3/1.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PLPlayerKit/PLPlayerKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLivePlayer : NSObject

@property (nonatomic, copy) void (^playComplete)(PLPlayerStatus status);

/**
 视频缓存目录，默认：/Document/PlayerVideo，如；
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *docDir = [paths objectAtIndex:0];
 NSString *filePath = [docDir stringByAppendingPathComponent:@"/PlayerVideo"];
 */
@property (nonatomic, strong) NSString *cacheVideoPath;

/**
 图片缓存目录，默认：/Document/PlayerImage，如：
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *docDir = [paths objectAtIndex:0];
 NSString *filePath = [docDir stringByAppendingPathComponent:@"/PlayerImage"];
 */
@property (nonatomic, strong) NSString *cacheImagePath;

@property (nonatomic, assign) CGFloat cacheSize;
@property (nonatomic, assign) CGFloat cacheImageSize;
@property (nonatomic, assign) CGFloat cacheVideoSize;

/// 是否缓存（默认不缓存，需要缓存时，初始化后即设置，否则无效）
@property (nonatomic, assign) BOOL cacheVideo;

// plist配置App Transport Security Settings
- (void)playWithUrl:(NSString *)url view:(UIView *)view;

- (void)play;

- (void)pause;

- (void)stop;

/**
 视频截图
 注意：
 1 plist配置NSPhotoLibraryAddUsageDescription
 2 PLPlayerOptionKeyVideoToolbox为NO时有效
 
 @param isSaveAlbum 是否保存到相册
 @param complete 截图回调
 */
- (void)screenShot:(BOOL)isSaveAlbum complete:(void (^)(UIImage *image, BOOL saveSuccess, BOOL saveAlbumSuccess))complete;

/// 是否全屏
- (void)fullScreen:(BOOL)isFull;

/// 清除全部缓存
- (void)clearCacheDefault;
/// 清除视频缓存
- (void)clearCacheVideo;
/// 清除图片缓存
- (void)clearCacheImage;

@end

NS_ASSUME_NONNULL_END

/*
 https://github.com/pili-engineering
 https://github.com/pili-engineering/PLPlayerKit
 
 1 配置你的 Podfile 文件，默认真机，添加如下配置信息
 pod 'PLPlayerKit'
 2 若需要使用模拟器 + 真机，则改用如下配置
 pod "PLPlayerKit", :podspec => 'https://raw.githubusercontent.com/pili-engineering/PLPlayerKit/master/PLPlayerKit-Universal.podspec'
 3 安装 CocoaPods 依赖: pod update 或 pod install
 
 4 info.plist配置
 App Transport Security Setting
 Required background modes
 
 5 使用
 #import <PLPlayerKit/PLPlayerKit.h>
 
 初始化 PLPlayerOption
 
 // 初始化 PLPlayerOption 对象
 PLPlayerOption *option = [PLPlayerOption defaultOption];
 
 // 更改需要修改的 option 属性键所对应的值
 [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
 [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
 [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
 [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
 [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
 
 初始化 PLPlayer
 
 // 初始化 PLPlayer
 self.player = [PLPlayer playerWithURL:self.URL option:option];
 
 // 设定代理 (optional)
 self.player.delegate = self;
 获取播放器的视频输出的 UIView 对象并添加为到当前 UIView 对象的 Subview
 
 //获取视频输出视图并添加为到当前 UIView 对象的 Subview
 [self.view addSubview:player.playerView];
 开始／暂停操作
 
 // 播放
 [self.player play];
 
 // 停止
 [self.player stop];
 
 // 暂停
 [self.player pause];
 
 // 继续播放
 [self.player resume];
 
 // 实现 <PLPlayerDelegate> 来控制流状态的变更
 - (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state
 {
 // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
 // 除了 Error 状态，其他状态都会回调这个方法
 // 开始播放，当连接成功后，将收到第一个 PLPlayerStatusCaching 状态
 // 第一帧渲染后，将收到第一个 PLPlayerStatusPlaying 状态
 // 播放过程中出现卡顿时，将收到 PLPlayerStatusCaching 状态
 // 卡顿结束后，将收到 PLPlayerStatusPlaying 状态
 }
 
 - (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error
 {
 // 当发生错误，停止播放时，会回调这个方法
 }
 
 - (void)player:(nonnull PLPlayer *)player codecError:(nonnull NSError *)error
 {
 // 当解码器发生错误时，会回调这个方法
 // 当 videotoolbox 硬解初始化或解码出错时
 // error.code 值为 PLPlayerErrorHWCodecInitFailed/PLPlayerErrorHWDecodeFailed
 // 播发器也将自动切换成软解，继续播放
 }
 
 
 */
