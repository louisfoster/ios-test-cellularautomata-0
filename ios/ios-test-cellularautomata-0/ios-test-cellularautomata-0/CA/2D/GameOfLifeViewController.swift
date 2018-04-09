//
//  GameOfLifeViewController.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 9/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import UIKit

class GameOfLifeViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet
    private var imageView: UIImageView?
    
    @IBOutlet
    private var toggleButton: UIButton?
    
    @IBOutlet
    private var resetButton: UIButton!
    
    private var gameOfLife: GameOfLifeProtocol?
    
    private var image: UIImage?
    
    private var iterating: Bool?
    private var tapMode: Bool?
    
    private var imageHeight: Int?
    private var imageWidth: Int?
    
    private var pixel0 = PixelData(r: 0, g: 0, b: 0)
    private var pixel1 = PixelData(r: 255, g: 255, b: 255)
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        
        self.imageView?.layer.magnificationFilter = kCAFilterNearest
        self.imageView?.layer.shouldRasterize = true
        
        //        self.imageWidth = Int(self.imageView?.bounds.width ?? 0)
        //        self.imageHeight = Int(self.imageView?.bounds.height ?? 0)
        
        self.imageWidth = 10
        self.imageHeight = 10
        
        self.iterating = false
        self.tapMode = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // self.iterating = false
        self.startCA()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // self.iterating = false
        self.gameOfLife = nil
    }
    
    // MARK: Actions
    
    func iterate(data: [UInt8]) {
        
        DispatchQueue.main.async {
            
            if let width = self.imageWidth, let height = self.imageHeight {
                
                var pix = [PixelData]()
                
                for item in data {
                    
                    pix.append(item == 0 ? self.pixel0 : self.pixel1)
                }
                
                self.image = imageFromRGB32Bitmap(pixels: pix, width: width, height: height)
                
                self.imageView?.image = self.image
                
            }
            
            self.gameOfLife?.updateStates(completion: { (data) in
                
                if self.iterating != true { return }
                self.iterate(data: data)
            })
        }
    }
    
    private func startCA() {
        
        if let width = self.imageWidth, let height = self.imageHeight {
            
            // self.gameOfLife = GameOfLife(width: width, height: height, initial: [35, 37, 46, 48, 55, 66, 67, 68])
            self.gameOfLife = GameOfLife(width: width, height: height)
        }
        
        if let cells = self.gameOfLife?.cells {
            
            self.iterate(data: cells)
        }
    }
    
    @IBAction
    private func toggleIteration(_ sender: Any) {
        
        if self.tapMode != true {
            
            self.iterating = self.iterating == true ? false : true
        }
        
        if let cells = self.gameOfLife?.cells {
            
            self.iterate(data: cells)
        }
    }
    
    @IBAction func resetCA(_ sender: Any) {
        
        self.startCA()
    }
}
