//
//  AVMoviePlayerStatusView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  状态视图（当前播放时间，剩余播放时间，播放进度，放大）

#import <UIKit/UIKit.h>

@interface AVMoviePlayerStatusView : UIView

/// 当前播放时间
@property (nonatomic, strong) UILabel *currentTimeLabel;

/// 剩余时间
@property (nonatomic, strong) UILabel *remainsTimeLabel;

/// 播放进度（拖拉）
@property (nonatomic, strong) UISlider *progressSlider;

/// 放大按钮
@property (nonatomic, strong) UIButton *scaleButton;

@end
