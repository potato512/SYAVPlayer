//
//  ReplayUtil.h
//  DemoRePlay
//
//  Created by zhangshaoyu on 2019/1/8.
//  Copyright © 2019年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <ReplayKit/ReplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReplayUtil : NSObject

- (void)startRecorder:(void (^)(BOOL isSuccess))complete;

- (void)stopRecorderWithTarget:(id)target complete:(void (^)(RPPreviewViewController *previewViewController, NSError *error))complete;

@end

NS_ASSUME_NONNULL_END
