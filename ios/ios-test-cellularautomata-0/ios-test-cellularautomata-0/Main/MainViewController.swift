//
//  MainViewController.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 8/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import UIKit

public struct PixelData {
    
    var r: UInt8 = 255
    var g: UInt8
    var b: UInt8
}

class MainViewController: UIViewController {
    
    @IBOutlet
    private var imageView: UIImageView?
    
    @IBOutlet
    private var toggleButton: UIButton?
    
    private var elementaryCA: ElementaryCAProtocol?
    
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
    
    private var image: UIImage?
    
    private var scrolling: Bool?
    
    private var imageHeight: Int?
    private var imageWidth: Int?
    
    private var pixels: [PixelData] = [PixelData]()
    private var pixel0 = PixelData(r: 0, g: 0, b: 0)
    private var pixel1 = PixelData(r: 255, g: 255, b: 255)
    
    override func viewDidLoad() {
        
        self.imageWidth = Int(self.imageView?.bounds.width ?? 0)
        self.imageHeight = Int(self.imageView?.bounds.height ?? 0)

//        self.imageWidth = 200
//        self.imageHeight = 200
        
        if let width = self.imageWidth, let height = self.imageHeight {
        
            self.elementaryCA = ElementaryCA(width: width, height: height)
        }
        
        self.scrolling = true
        self.scroll()
    }
    
    func scroll() {
        
        if self.scrolling != true { return }
        
        DispatchQueue.main.async {
            
            self.elementaryCA?.updateStates(completion: { (data) in
                
                if let width = self.imageWidth, let height = self.imageHeight {
                    
                    let values = data.count != self.pixels.count ? data : Array(data[(data.count - width)...])
                    var pix = data.count != self.pixels.count ? [PixelData]() : Array(self.pixels[width...])
                    
                    for item in values {
                        
                        pix.append(item == 0 ? self.pixel0 : self.pixel1)
                    }
                    
                    self.image = self.imageFromRGB32Bitmap(pixels: pix, width: width, height: height)
                   
                    self.imageView?.image = self.image
                    self.pixels = pix
                    
                    self.scroll()
                }
            })
        }
    }
    
    @IBAction func toggleScrolling(_ sender: Any) {
        
        self.scrolling = self.scrolling == true ? false : true
        self.scroll()
    }
    
    // From: http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
    public func imageFromRGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage {
        
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
}
