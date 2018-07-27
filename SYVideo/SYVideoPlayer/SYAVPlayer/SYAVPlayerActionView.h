//
//  SYAVPlayerActionView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  视频播放交互视图（标题，网络状态，缓冲进度，播放或暂停，状态）

#import <UIKit/UIKit.h>

@interface SYAVPlayerActionView : UIView

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

/// 网络状态
@property (nonatomic, strong) UILabel *networkLabel;

/// 缓冲进度
@property (nonatomic, strong) UIActivityIndicatorView *cacheView;

/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playButton;

@end
