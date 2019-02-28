//
//  AVPlayerControllerVC.m
//  DemoVideoPlay
//
//  Created by zhangshaoyu on 2019/2/27.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "AVPlayerControllerVC.h"
// 导入封装方法头文件
#import"SYVideo.h"

@interface AVPlayerControllerVC ()

@end

@implementation AVPlayerControllerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"本地", @"网络"]];
    segment.frame = CGRectMake(0.0, 0.0, 200.0, 44.0);
    [segment addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)dealloc{
    NSLog(@"释放了 %@~", self.class);
}

// 按钮播放事件
- (void)playClick:(UISegmentedControl *)button
{
    // 本地文件
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    // 视频文件
    if (button.selectedSegmentIndex == 1) {
        moviePath = @"http://devimages.apple.com/iphone/samples/bipbop/gear4/prog_index.m3u8";
    }

    SYAVPlayerController *player = [[SYAVPlayerController alloc] init];
    [player playWithFilePath:moviePath target:self];
    
}

@end
