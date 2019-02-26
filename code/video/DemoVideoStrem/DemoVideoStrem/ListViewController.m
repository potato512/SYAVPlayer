//
//  ListViewController.m
//  DemoVideoStrem
//
//  Created by zhangshaoyu on 2019/2/26.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "ListViewController.h"
#import "ViewController.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *array;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"播放列表";
    
    [self setUI];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)setUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
}

- (NSArray *)array
{
    if (_array == nil) {
        _array = @[@{@"name":@"苹果示例", @"url":@"http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8"},
                   @{@"name":@"2", @"url":@"http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8"},
                   @{@"name":@"3", @"url":@"rtmp://192.168.43.59/live/record1"},
                   @{@"name":@"喜欢你", @"url":@"http://221.228.226.23/11/t/j/v/b/tjvbwspwhqdmgouolposcsfafpedmb/sh.yinyuetai.com/691201536EE4912BF7E4F1E2C67B8119.mp4"},
                   @{@"name":@"5", @"url":@"http://221.228.226.5/14/z/w/y/y/zwyyobhyqvmwslabxyoaixvyubmekc/sh.yinyuetai.com/4599015ED06F94848EBF877EAAE13886.mp4"},
                   @{@"name":@"时钟", @"url":@"http://demo-videos.qnsdk.com/movies/moon.mp4"},
                   @{@"name":@"测试环境", @"url":@"rtmp://139.9.29.150:1935/hls/test"}];
    }
    return _array;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    NSDictionary *dict = self.array[indexPath.row];
    NSString *title = dict[@"name"];
    NSString *url = dict[@"url"];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = url;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.array[indexPath.row];
    NSString *title = dict[@"name"];
    NSString *url = dict[@"url"];
    
    ViewController *nextVC = [[ViewController alloc] init];
    nextVC.urlTitle = title;
    nextVC.urlText = url;
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
