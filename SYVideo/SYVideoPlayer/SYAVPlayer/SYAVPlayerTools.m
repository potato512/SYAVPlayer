//
//  SYAVPlayerTools.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYAVPlayerTools.h"

@implementation SYAVPlayerTools

+ (NSDictionary *)convertSecond2HourMinuteSecond:(int)second
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    int hour = 0, minute = 0;
    
    hour = second / 3600;
    minute = (second - hour * 3600) / 60;
    second = second - hour * 3600 - minute *  60;
    
    [dict setObject:[NSNumber numberWithInt:hour] forKey:@"hour"];
    [dict setObject:[NSNumber numberWithInt:minute] forKey:@"minute"];
    [dict setObject:[NSNumber numberWithInt:second] forKey:@"second"];
    
    return dict;
}

- (NSString *)getTimeString:(NSDictionary *)dict prefix:(NSString *)prefix
{
    int hour = [[dict objectForKey:@"hour"] intValue];
    int minute = [[dict objectForKey:@"minute"] intValue];
    int second = [[dict objectForKey:@"second"] intValue];
    
    NSString *formatter = hour < 10 ? @"0%d" : @"%d";
    NSString *strHour = [NSString stringWithFormat:formatter, hour];
    
    formatter = minute < 10 ? @"0%d" : @"%d";
    NSString *strMinute = [NSString stringWithFormat:formatter, minute];
    
    formatter = second < 10 ? @"0%d" : @"%d";
    NSString *strSecond = [NSString stringWithFormat:formatter, second];
    
    return [NSString stringWithFormat:@"%@%@:%@:%@", prefix, strHour, strMinute, strSecond];
}

/**
 *  时间格式转换（秒数转换成时间字符串）
 *
 *  @param second 秒数
 *  @param prefix 字符串前缀（如：@""，或@"-"）
 *
 *  @return NSString
 */
+ (NSString *)timeStringWithSecond:(NSTimeInterval)second prefix:(NSString *)prefix
{
    int hourTmp = second / 3600;
    int minuteTmp = (second - hourTmp * 3600) / 60;
    int secondTmp = second - hourTmp * 3600 - minuteTmp * 60;
    
    NSString *formatter = (hourTmp < 10 ? @"0%d" : @"%d");
    NSString *strHour = [NSString stringWithFormat:formatter, hourTmp];
    
    formatter = (minuteTmp < 10 ? @"0%d" : @"%d");
    NSString *strMinute = [NSString stringWithFormat:formatter, minuteTmp];
    
    formatter = (secondTmp < 10 ? @"0%d" : @"%d");
    NSString *strSecond = [NSString stringWithFormat:formatter, secondTmp];
    
    return [NSString stringWithFormat:@"%@%@:%@:%@", prefix, strHour, strMinute, strSecond];
}

#pragma mark - 播放地址

+ (NSURL *)playerUrl:(NSString *)url
{
    if ([self isNetworkUrl:url]) {
        // 网络视频
        NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *result = [NSURL URLWithString:urlStr];
        return result;
    } else {
        // 本地视频
        if ([[NSFileManager defaultManager] fileExistsAtPath:url])
        {
            NSURL *result = [NSURL fileURLWithPath:url];
            return result;
        }
    }
    return nil;
}

+ (BOOL)isNetworkUrl:(NSString *)url
{
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        // 网络视频
        return YES;
    }
    
    // 本地视频
    return NO;
}

@end
