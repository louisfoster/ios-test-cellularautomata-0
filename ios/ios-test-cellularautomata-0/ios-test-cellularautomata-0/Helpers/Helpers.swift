//
//  UIImage.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 9/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import UIKit

public struct PixelData {
    
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

// From: http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
public func imageFromRGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage {
    
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
    
    let bitsPerComponent: Int = 8
    let bitsPerPixel: Int = 24
    
    assert(pixels.count == width * height)
    
    var data = pixels // Copy to mutable []
    let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * MemoryLayout<PixelData>.stride))
    
    if let cgim = CGImage(
        width: width,
        height: height,
        bitsPerComponent: bitsPerComponent,
        bitsPerPixel: bitsPerPixel,
        bytesPerRow: width * Int(MemoryLayout<PixelData>.stride),
        space: rgbColorSpace,
        bitmapInfo: bitmapInfo,
        provider: providerRef!,
        decode: nil,
        shouldInterpolate: true,
        intent: CGColorRenderingIntent.defaultIntent
        ) {
        
        return UIImage(cgImage: cgim)
    }
    
    return UIImage()
}
