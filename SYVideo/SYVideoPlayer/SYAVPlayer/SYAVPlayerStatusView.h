//
//  SYAVPlayerStatusView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  状态视图（当前播放时间，剩余播放时间，播放进度，放大）

#import <UIKit/UIKit.h>

/// 界面显示类型
typedef NS_ENUM(NSInteger, SYAVPlayerStatusViewType) {
    /// 界面显示类型（默认样式）-已播放时间、剩余播放时间，拖拉进度、放大按钮
    SYAVPlayerStatusViewTypeDefault = 0,
    
    /// 界面显示类型（默认样式）-播放暂停按钮、剩余播放时间，拖拉进度、放大按钮
    SYAVPlayerStatusViewTypeBottom = 1
};

@interface SYAVPlayerStatusView : UIView

/// 界面显示类型
@property (nonatomic, assign) SYAVPlayerStatusViewType viewType;

/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playButton;

/// 当前播放时间
@property (nonatomic, strong) UILabel *currentTimeLabel;

/// 剩余时间
@property (nonatomic, strong) UILabel *remainsTimeLabel;

/// 播放进度（拖拉）
@property (nonatomic, strong) UISlider *progressSlider;

/// 放大按钮
@property (nonatomic, strong) UIButton *scaleButton;

@end
