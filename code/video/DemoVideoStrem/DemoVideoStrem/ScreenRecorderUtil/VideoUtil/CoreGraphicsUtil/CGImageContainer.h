//
//  CGImageContainer.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2019/2/12.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGImageContainer : NSObject

/**
 * The image that this container encloses.
 */
@property (readonly) CGImageRef image;

/**
 * Create a new image container with an image.
 * @param anImage Will be retained and enclosed in this class.
 * This object will be released when the CGImageContainer is
 * deallocated.  This can be nil.
 * @return The new image container, or nil if anImage is nil.
 */
- (id)initWithImage:(CGImageRef)image;

/**
 * Create a new image container with an image.
 * @param anImage Will be retained and enclosed in this class.
 * This object will be released when the CGImageContainer is
 * deallocated.  This can be nil.
 * @return The new image container, or nil if anImage is nil.
 * The image container returned will be autoreleased.
 */
+ (CGImageContainer *)imageContainerWithImage:(CGImageRef)image;

@end

NS_ASSUME_NONNULL_END
