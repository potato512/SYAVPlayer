//
//  ViewController.m
//  DemoRePlay
//
//  Created by zhangshaoyu on 2019/1/8.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"

#import "ReplayUtil/ReplayUtil.h"

@interface ViewController ()

@property (nonatomic, strong) ReplayUtil *recorderUtil;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"录制屏幕";
    //
    UIBarButtonItem *itemRecord = [[UIBarButtonItem alloc] initWithTitle:@"record" style:UIBarButtonItemStyleDone target:self action:@selector(recordClick)];
    UIBarButtonItem *itemStop = [[UIBarButtonItem alloc] initWithTitle:@"stop" style:UIBarButtonItemStyleDone target:self action:@selector(stopClick)];
    UIBarButtonItem *itemPlay = [[UIBarButtonItem alloc] initWithTitle:@"play" style:UIBarButtonItemStyleDone target:self action:@selector(playClick)];
    self.navigationItem.rightBarButtonItems = @[itemPlay, itemStop, itemRecord];
    //
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 20.0, 200.0, 120.0)];
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    imageView.animationImages = @[[UIImage imageNamed:@"img_01"], [UIImage imageNamed:@"img_02"], [UIImage imageNamed:@"img_03"], [UIImage imageNamed:@"img_04"]];
    imageView.animationDuration = 1;
    [imageView startAnimating];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:panRecognizer];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)panClick:(UIPanGestureRecognizer *)recognizer
{
    UIView *view = recognizer.view;
    
//    CGPoint point = [recognizer translationInView:self.view];
//    CGFloat centerX = view.center.x + point.x;
//    CGFloat centerY = view.center.y + point.y;
//    view.center = CGPointMake(centerX, centerY);
//    [recognizer setTranslation:CGPointZero inView:view];
    
    // 获取偏移量
    // 返回的是相对于最原始的手指的偏移量
    CGPoint transP = [recognizer translationInView:self.view];
    // 移动图片控件
    view.transform = CGAffineTransformTranslate(view.transform, transP.x, transP.y);
    // 复位,表示相对上一次
    [recognizer setTranslation:CGPointZero inView:view];
}

#pragma mark - 录屏功能

- (void)recordClick
{
    [self.recorderUtil startRecorder:^(BOOL isSuccess) {
        
    }];
}

- (void)stopClick
{
    [self.recorderUtil stopRecorderWithTarget:self complete:^(RPPreviewViewController *previewViewController, NSError *error) {
        
    }];
}

- (void)playClick
{
    
}

- (ReplayUtil *)recorderUtil
{
    if (_recorderUtil == nil) {
        _recorderUtil = [[ReplayUtil alloc] init];
    }
    return _recorderUtil;
}

@end
