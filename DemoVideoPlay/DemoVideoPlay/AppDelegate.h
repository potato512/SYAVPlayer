//
//  AppDelegate.h
//  DemoVideoPlay
//
//  Created by zhangshaoyu on 16/11/4.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 标记是否可以旋转
@property (nonatomic, assign) BOOL allowRotation;

@end

