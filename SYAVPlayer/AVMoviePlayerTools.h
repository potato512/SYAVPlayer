//
//  AVMoviePlayerTools.h
//  DemoVideoPlay
//
//  Created by zhangshaoyu on 16/11/10.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  视频播放逻辑处理类

#import <Foundation/Foundation.h>

@interface AVMoviePlayerTools : NSObject

/**
 *  时间格式转换（秒数转换成时间字符串）
 *
 *  @param second 秒数
 *  @param prefix 字符串前缀（如：@""，或@"-"）
 *
 *  @return NSString
 */
+ (NSString *)timeStringWithSecond:(NSTimeInterval)second prefix:(NSString *)prefix;

@end
