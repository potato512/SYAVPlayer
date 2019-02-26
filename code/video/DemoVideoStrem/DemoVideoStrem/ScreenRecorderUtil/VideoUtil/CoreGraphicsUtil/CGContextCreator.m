//
//  CGContextCreator.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/12.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import "CGContextCreator.h"

@implementation CGContextCreator

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (CGContextRef)RGBBitmapContextWithSize:(CGSize)size
{
    size_t pixelsWidht = round(size.width);
    size_t pixelsHeight = round(size.height);
    int bitmapBytesPerRow = (int)(pixelsWidht * 4);
    int bitmapByte = (int)(bitmapBytesPerRow * pixelsHeight);
    
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
    if (colorRef == NULL) {
        return NULL;
    }
    
    void *bitmap = malloc(bitmapByte);
    if (bitmap == NULL) {
        CGColorSpaceRelease(colorRef);
        return NULL;
    }
    
    CGContextRef contextRef = CGBitmapContextCreate(bitmap, pixelsWidht, pixelsHeight, 8, bitmapBytesPerRow, colorRef, kCGImageAlphaPremultipliedFirst);
    if (contextRef == NULL) {
        free(bitmap);
    }
    
    CGContextClearRect(contextRef, CGRectMake(0.0, 0.0, size.width, size.height));
    CGColorSpaceRelease(colorRef);
    
    return contextRef;
}

+ (CGContextRef)RGBBitmapContextWithImage:(CGImageRef)image
{
    size_t pixelsWidth = CGImageGetWidth(image);
    size_t pixelsHeight = CGImageGetHeight(image);
    int bitmapBytesPerRow = (int)(pixelsWidth * 4);
    int bitmapByte = (int)(bitmapBytesPerRow * pixelsHeight);
    
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
    if (colorRef == NULL) {
        return NULL;
    }
    
    void *bitmap = malloc(bitmapByte);
    if (bitmap == NULL) {
        CGColorSpaceRelease(colorRef);
        return NULL;
    }
    
    CGContextRef contextRef = CGBitmapContextCreate(bitmap, pixelsWidth, pixelsHeight, 8, bitmapBytesPerRow, colorRef, kCGImageAlphaPremultipliedFirst);
    if (contextRef == NULL) {
        free(bitmap);
    }
    CGContextClearRect(contextRef, CGRectMake(0.0, 0.0, CGImageGetWidth(image), CGImageGetHeight(image)));
    CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    CGColorSpaceRelease(colorRef);
    
    return contextRef;
}

@end
