//
//  UIImage+Category.h
//  CZImage
//
//  Created by guaker on 2019/11/16.
//  Copyright © 2019 giantcro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)

/// 裁剪图片周围透明部分
- (UIImage *)cutAlphaZero;

@end

NS_ASSUME_NONNULL_END
