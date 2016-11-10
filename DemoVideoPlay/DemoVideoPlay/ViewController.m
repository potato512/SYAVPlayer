//
//  ViewController.m
//  DemoVideoPlay
//
//  Created by zhangshaoyu on 16/11/4.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "MPMoviePlayerVC.h"
#import "AVPlayerVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *mainArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:mainTableView];
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mainTableView.tableFooterView = [[UIView alloc] init];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
}

#pragma mark - 数据 

- (NSArray *)mainArray
{
    if (_mainArray == nil)
    {
        _mainArray = @[@"MPMoviePlayerViewController", @"AVPlayer"];
    }
    
    return _mainArray;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSString *text = self.mainArray[indexPath.row];
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.row)
    {
        MPMoviePlayerVC *nextVC = [[MPMoviePlayerVC alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else if (1 == indexPath.row)
    {
        AVPlayerVC *nextVC = [[AVPlayerVC alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

@end
