# SYVideo
使用SYVideo进行视频的录制和播放，及视频信息的处理。 视频播放既可以播放本地视频，也可以播放网络视频，且可以进行视频直播；视频信息处理，既可以按需获取视频的图片，也可以对视频进行裁剪，同时可以获取视频的实体信息（如：地址、名称、类型、大小、时长）；另外也可以对视频进行压缩处理。

* 视频录制
* 视频播放
  * 本地视频
    * 全屏切换
    * 进度拖拉
    * 音量调节
    * 亮度调节
  * 网络视频
  * 直播视频
    * 推流
    * 拉流
* 视频信息
  * 地址
  * 名称
  * 类型
  * 大小
  * 时长
* 视频操作
  * 截图
  * 裁剪
  * 拼接
  * 压缩
  * 重命名
  * 移动
  * 复制
  * 删除
  * 保存到相册
  * 全屏切换




# MPMoviePlayerViewController播放视频
视频播放（使用系统MPMoviePlayerViewController，MPMoviePlayerController）

使用`SYMPMoviePlayer`播放视频（在线，或本地），全屏模式。
```
// 导入封装方法头文件
#import "SYMPMoviePlayer.h"

// 播放视频
// 本地视频文件
// NSString *moviePath = NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie02" ofType:@"mov"];;
// 网络视频文件
NSString *moviePath = @"http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8";

[[SYMPMoviePlayer shareMPMoviePlayer] playWithFilePath:moviePath target:self];
```

> 注意：
> 1、添加“MediaPlayer.framework”库
> 2、#import <MediaPlayer/MediaPlayer.h>

# 效果图

![SYMPMoviePlayer](./SYMPMoviePlayer.gif)



使用`AVMoviePlayer`播放视频（自定义大小和位置）
```
// 导入头文件
#import "AVMoviePlayer.h"

// 播放视频
// 本地视频
NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"movie02" ofType:@"mov"];
// 网络视频
// NSString *urlStr = @"http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8";
CGRect rect = CGRectMake(10.0, 10.0, (self.view.bounds.size.width - 10.0 * 2), 200.0);
AVMoviePlayer *player = [[AVMoviePlayer alloc] initWithFrame:rect];
[self.view addSubview:player];
player.videoUrl = urlStr;
player.videoTitle = @"本地视频";
player.playerView.playerStatusView.scaleButton.hidden = YES;
SYAVPlayerSelfWeak;
player.scaleClick = ^(BOOL isFullScreen){
    SYAVPlayerDelegate.allowRotation = isFullScreen;
    [SYAVPlayerWeakSelf.navigationController setNavigationBarHidden:isFullScreen animated:YES];
};
```

> 注意：
> 1 添加 AVFoundation.framework 库
> 2 导入头文件 #import <AVFoundation/AVFoundation.h>

# 效果图

![AVMoviePlayer](./AVMoviePlayer.gif)



#### 修改完善
* 20190228
  * 版本号：
  * 删除MPMoviePlayerViewController播放视频功能

  
* 20180721 
  * 版本号：1.0.0
  * 源码
  

