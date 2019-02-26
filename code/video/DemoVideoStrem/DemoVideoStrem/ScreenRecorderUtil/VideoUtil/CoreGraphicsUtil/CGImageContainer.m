//
//  CGImageContainer.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/12.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "CGImageContainer.h"

@interface CGImageContainer ()
{
    CGImageRef imageRef;
}

@end

@implementation CGImageContainer

- (id)initWithImage:(CGImageRef)image
{
    self = [super init];
    if (self) {
        imageRef = image;
    }
    return self;
}

+ (CGImageContainer *)imageContainerWithImage:(CGImageRef)image
{
    CGImageContainer *container = [[CGImageContainer alloc] initWithImage:image];
    return container;
}

- (void)dealloc
{
    CGImageRelease(imageRef);
}

- (CGImageRef)image
{
    return imageRef;
}

@end
