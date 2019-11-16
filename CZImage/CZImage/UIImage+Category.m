//
//  UIImage+Category.m
//  CZImage
//
//  Created by guaker on 2019/11/16.
//  Copyright © 2019 giantcro. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

//pragma mark - 裁剪掉周围的透明部分
- (UIImage *)cutAlphaZero {
    CGImageRef cgImage = [self CGImage];
    
    size_t width = CGImageGetWidth(cgImage); // 图片宽度
    size_t height = CGImageGetHeight(cgImage); // 图片高度
    
    unsigned char *data = calloc(width * height * 4, sizeof(unsigned char)); // 取图片首地址
    size_t bitsPerComponent = 8; // r g b a 每个component bits数目
    size_t bytesPerRow = width * 4; // 一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间
    
    CGContextRef context = CGBitmapContextCreate(data, width,height,bitsPerComponent,bytesPerRow,space,kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    int top = 0;  // 上边框透明高度
    int left = 0; // 左边框透明高度
    int right = 0; // 右边框透明高度
    int bottom = 0; // 底边框透明高度
    
    for (size_t row = 0; row < height; row++) {
        BOOL find = false;
        for (size_t col = 0; col < width; col++) {
            size_t pixelIndex = (row * width + col) * 4;
            int alpha = data[pixelIndex + 3];
            if (alpha != 0) {
                find = YES;
                break;
            }
        }
        if (find) {
            break;
        }
        top ++;
    }
    
    for (size_t col = 0; col < width; col++) {
        BOOL find = false;
        for (size_t row = 0; row < height; row++) {
            size_t pixelIndex = (row * width + col) * 4;
            
            int alpha = data[pixelIndex + 3];
            if (alpha != 0) {
                find = YES;
                break;
            }
        }
        if (find) {
            break;
        }
        left ++;
    }
    
    for (size_t col = width - 1; col > 0; col--) {
        BOOL find = false;
        for (size_t row = 0; row < height; row++) {
            size_t pixelIndex = (row * width + col) * 4;
            
            int alpha = data[pixelIndex + 3];
            if (alpha != 0) {
                find = YES;
                break;
            }
        }
        if (find) {
            break;
        }
        right ++;
    }
    
    for (size_t row = height - 1; row > 0; row--) {
        BOOL find = false;
        for (size_t col = 0; col < width; col++) {
            size_t pixelIndex = (row * width + col) * 4;
            int alpha = data[pixelIndex + 3];
            if (alpha != 0) {
                find = YES;
                break;
            }
        }
        if (find) {
            break;
        }
        bottom ++;
    }
    

    CGFloat scale = self.scale;
    CGImageRef newImageRef = CGImageCreateWithImageInRect(cgImage, CGRectMake(left, top, self.size.width * scale - left - right, self.size.height * scale - top - bottom));
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // 释放
    CGImageRelease(cgImage);
    CGContextRelease(context);
    CGColorSpaceRelease(space);
    return  newImage;
}

@end
