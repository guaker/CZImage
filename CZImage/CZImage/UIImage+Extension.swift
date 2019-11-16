//
//  UIImage+Category.swift
//  CZImage
//
//  Created by guaker on 2019/11/16.
//  Copyright © 2019 giantcro. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 裁剪图片周围透明部分
    func cutAlphaZero() -> UIImage? {
        guard let cgImage: CGImage = self.cgImage else {
            return nil
        }
        
        let width: size_t = cgImage.width //图片宽度
        let height: size_t = cgImage.height //图片高度
        
        let data = calloc(width * height * 4, MemoryLayout<UInt8>.size) // 取图片首地址 unsigned char
        let bitsPerComponent: size_t = 8 //r g b a 每个component bits数目
        let bytesPerRow: size_t = width * 4 // 一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
        let space: CGColorSpace = CGColorSpaceCreateDeviceRGB() // 创建rgb颜色空间
        
        guard let context: CGContext = CGContext(
            data: data,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: space,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Big.rawValue)
            else {
                return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var top: Int = 0 // 上边框透明高度
        var left: Int = 0 // 左边框透明高度
        var right: Int = 0 // 右边框透明高度
        var bottom: Int = 0 // 底边框透明高度
        
        for row: size_t in 0 ..< height {
            var find: Bool = false
            for col: size_t in 0 ..< width {
                let pixelIndex: size_t = (row * width + col) * 4
                let bufferPointer = UnsafeRawBufferPointer(start: data, count: width * height * 4)
                
                let alpha = bufferPointer[pixelIndex + 3]
                if alpha != 0 {
                    find = true
                    break
                }
            }
            if find {
                break
            }
            top += 1
        }
        
        for col: size_t in 0 ..< width {
            var find: Bool = false
            for row: size_t in 0 ..< height {
                let pixelIndex: size_t = (row * width + col) * 4
                let bufferPointer = UnsafeRawBufferPointer(start: data, count: width * height * 4)
                let alpha = bufferPointer[pixelIndex + 3]
                if alpha != 0 {
                    find = true
                    break
                }
            }
            if find {
                break
            }
            left += 1
        }
        
        for col: size_t in (1 ..< width).reversed() {
            var find: Bool = false
            for row: size_t in 0 ..< height {
                let pixelIndex: size_t = (row * width + col) * 4
                let bufferPointer = UnsafeRawBufferPointer(start: data, count: width * height * 4)
                let alpha = bufferPointer[pixelIndex + 3]
                if alpha != 0 {
                    find = true
                    break
                }
            }
            if find {
                break
            }
            right += 1
        }
        
        for row: size_t in (1 ..< height).reversed() {
            var find: Bool = false
            for col: size_t in 0 ..< width {
                let pixelIndex: size_t = (row * width + col) * 4
                let bufferPointer = UnsafeRawBufferPointer(start: data, count: width * height * 4)
                let alpha = bufferPointer[pixelIndex + 3]
                if alpha != 0 {
                    find = true
                    break
                }
            }
            if find {
                break
            }
            bottom += 1
        }
        
        
        let scale = self.scale
        guard let newCgImage: CGImage = cgImage.cropping(
            to: CGRect(x: CGFloat(left),
                       y: CGFloat(top),
                       width: self.size.width * scale - CGFloat(left) - CGFloat(right),
                       height: self.size.height * scale - CGFloat(top) - CGFloat(bottom)))
            else {
                return nil
        }
        
        
        let newImage = UIImage(cgImage: newCgImage)
        
        return newImage
        
    }
    
    
    
}
