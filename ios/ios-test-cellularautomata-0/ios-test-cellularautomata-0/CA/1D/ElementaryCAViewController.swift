//
//  ElementaryCAViewController.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 9/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import UIKit

/*
 
 A six state colour system could also be used (red, violet, blue, aqua, green, yellow)
 Image could also be a half image mirrored vertically
 
 */

class ElementaryCAViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet
    private var imageView: UIImageView?
    
    @IBOutlet
    private var toggleButton: UIButton?
    
    private var elementaryCA: ElementaryCAProtocol?
    
    private var image: UIImage?
    
    private var iterating: Bool?
    private var tapMode: Bool?
    
    private var imageHeight: Int?
    private var imageWidth: Int?
    
    private var pixels: [PixelData] = [PixelData]()
    private var pixel0 = PixelData(r: 0, g: 0, b: 0)
    private var pixel1 = PixelData(r: 255, g: 255, b: 255)
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        
        self.imageView?.layer.magnificationFilter = kCAFilterNearest
        self.imageView?.layer.shouldRasterize = true
        
        //        self.imageWidth = 10
        //        self.imageHeight = 10
        
        self.imageWidth = Int(self.imageView?.bounds.width ?? 0)
        self.imageHeight = Int(self.imageView?.bounds.height ?? 0)
        
        self.iterating = true
        self.tapMode = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.iterating = true
        self.startCA()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.iterating = false
        self.elementaryCA = nil
    }
    
    // MARK: Actions
    
    func iterate(data: [UInt8]) {
        
        DispatchQueue.main.async {
            
            if let width = self.imageWidth, let height = self.imageHeight {
                
                let values = data.count != self.pixels.count ? data : Array(data[(data.count - width)...])
                var pix = data.count != self.pixels.count ? [PixelData]() : Array(self.pixels[width...])
                
                for item in values {
                    
                    pix.append(item == 0 ? self.pixel0 : self.pixel1)
                }
                
                self.image = imageFromRGB32Bitmap(pixels: pix, width: width, height: height)
                
                self.imageView?.image = self.image
                self.pixels = pix
            }
            
            self.elementaryCA?.updateStates(completion: { (data) in
         
                if self.iterating != true { return }
                self.iterate(data: data)
            })
        }
    }
    
    private func startCA() {
        
        if let width = self.imageWidth, let height = self.imageHeight {
            
            self.elementaryCA = ElementaryCA(width: width, height: height)
        }
        
        if let cells = self.elementaryCA?.listOfCells {
            
            self.iterate(data: cells)
        }
    }
    
    @IBAction
    private func toggleIteration(_ sender: Any) {
        
        if self.tapMode != true {
            
            self.iterating = self.iterating == true ? false : true
        }
        
        if let cells = self.elementaryCA?.listOfCells {
            
            self.iterate(data: cells)
        }
    }

}
