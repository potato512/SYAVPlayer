# SYAVPlayer
使用AVPlayer自定义视频播放器，播放网络视频，或本地视频


// 参考示例
https://www.jianshu.com/p/fe00883ad3d2
https://blog.csdn.net/vkooy/article/details/65442600
https://blog.csdn.net/wang631106979/article/details/51498009
https://www.jianshu.com/p/86a5393d0e72
http://www.cocoachina.com/ios/20160518/16328.html
https://www.jianshu.com/p/7c57c58c253d
https://www.jianshu.com/p/7ee9de4a1f29
https://www.jianshu.com/p/6d488a0aee96
https://www.jianshu.com/p/12db0663cda1
https://blog.csdn.net/u013749108/article/details/80455881
https://www.jb51.net/article/109303.htm

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
* 20180721 
  * 版本号：1.0.0
  * 源码
  

