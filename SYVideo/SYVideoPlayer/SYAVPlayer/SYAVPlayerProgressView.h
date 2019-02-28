//
//  SYAVPlayerProgressView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/28.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYAVPlayerProgressView : UIView

/// 进度（默认0，范围0.0~1.0）
@property(nonatomic, assign) float progress;
/// 进度条颜色
@property(nonatomic, strong, nullable) UIColor *progressTintColor;
/// 进度条背景颜色
@property(nonatomic, strong, nullable) UIColor *trackTintColor;

@end

NS_ASSUME_NONNULL_END
