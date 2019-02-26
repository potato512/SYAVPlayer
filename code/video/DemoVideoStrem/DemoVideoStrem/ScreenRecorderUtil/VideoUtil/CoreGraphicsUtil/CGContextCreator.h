//
//  CGContextCreator.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/12.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGContextCreator : NSObject

+ (CGContextRef)RGBBitmapContextWithSize:(CGSize)size;

+ (CGContextRef)RGBBitmapContextWithImage:(CGImageRef)image;

@end

NS_ASSUME_NONNULL_END
