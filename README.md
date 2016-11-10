# SYAVPlayer
使用AVPlayer自定义视频播放器，播放网络视频，或本地视频


# MPMoviePlayerViewController播放视频
视频播放（使用系统MPMoviePlayerViewController，MPMoviePlayerController）

~~~ javaacript

// 导入封装方法头文件
#import "SYMPMoviePlayer.h"

// 播放视频
// 本地视频文件
// NSString *moviePath = NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie02" ofType:@"mov"];;
// 网络视频文件
NSString *moviePath = @"http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8";

[[SYMPMoviePlayer shareMPMoviePlayer] playWithFilePath:moviePath target:self];

~~~

# 效果图
![SYMPMoviePlayer](./SYMPMoviePlayer.png)

