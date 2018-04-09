//
//  MainViewController.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 8/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet
    private var elementaryCAButton: UIButton?
    
    @IBOutlet
    private var gameOfLifeButton: UIButton?
    
    @IBOutlet
    private var gameOfLife3DButton: UIButton?
    
    private var elementaryCAController: UIViewController?
    private var gameOfLifeController: UIViewController?
    private var gameOfLife3DController: UIViewController?
    
    override func viewDidLoad() {
        
        self.elementaryCAController = ElementaryCAViewController()
        self.gameOfLifeController = GameOfLifeViewController()
        self.gameOfLife3DController = GameOfLife3DViewController()
    }
    
    @IBAction
    private func loadElementary(_ sender: Any) {
        
        if let controller = self.elementaryCAController {
        
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func loadGameOfLife(_ sender: Any) {
        
        if let controller = self.gameOfLifeController {
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func loadGameOfLife3D(_ sender: Any) {
        
        if let controller = self.gameOfLife3DController {
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
