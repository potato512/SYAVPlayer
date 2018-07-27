//
//  RecorderAVCaptureSessionWriteVC.m
//  DemoVideoPlay
//
//  Created by zhangshaoyu on 2018/7/27.
//  Copyright © 2018年 zhangshaoyu. All rights reserved.
//

#import "RecorderAVCaptureSessionWriteVC.h"

@interface RecorderAVCaptureSessionWriteVC ()

@end

@implementation RecorderAVCaptureSessionWriteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"视频播放";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

#pragma mark - 视图

- (void)setUI
{
    
}

@end
