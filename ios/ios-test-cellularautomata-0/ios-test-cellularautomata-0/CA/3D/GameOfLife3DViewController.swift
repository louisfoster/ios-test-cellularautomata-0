//
//  GameOfLife3DViewController.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 9/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import UIKit
import SceneKit

/*
 TODO:
 
 * Setup reset + iterator buttons
 * Setup scene kit view
 * Scene
 * Free camera
 * Lighting
 * Display cube with nice material/color/shadows
 * Display vectors at world origin
 - Load GOL3D
 - Load GOL3D data into scene
   - Use cube for each data point
 */

class GameOfLife3DViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet
    private var scnView: SCNView?
    
    @IBOutlet
    private var iterateButton: UIButton?
    
    @IBOutlet
    private var resetButton: UIButton?
    
    private var scene: SCNScene?
    private var cubeHolder: SCNNode = SCNNode()
    
    private var area: SCNVector3?
    
    private var gameOfLife3D: GameOfLife3D?
    
    private var iterating: Bool?
    private var tapMode: Bool?
    
    // MARK: Setup
    
    private func setupScene() {
        
        self.scene = SCNScene()
        
        let gimbal = Gimbal()
        self.scene?.rootNode.addChildNode(gimbal)
        
        let camera = SCNNode()
        camera.camera = SCNCamera()
        camera.position = SCNVector3(x: 0, y: 10, z: 0)
        camera.look(at: SCNVector3(x: 0, y: 0, z: 0))
        self.scene?.rootNode.addChildNode(camera)
        
        let spotLights = [
            SCNVector3(x: -20, y: 20, z: -20),
            SCNVector3(x: 20, y: -20, z: 20)
        ]
        
        for position in spotLights {
            
            let spotLightNode = SCNNode()
            spotLightNode.position = position
            spotLightNode.look(at: SCNVector3(x: 0, y: 0, z: 0))
            spotLightNode.light = SCNLight()
            spotLightNode.light?.type = .spot
            spotLightNode.light?.intensity = CGFloat(100 + position.y)
            spotLightNode.light?.castsShadow = true
            self.scene?.rootNode.addChildNode(spotLightNode)
        }
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.intensity = 100
        self.scene?.rootNode.addChildNode(ambientLightNode)
        
        self.scene?.rootNode.addChildNode(self.cubeHolder)
        
        self.scnView?.allowsCameraControl = true
        self.scnView?.showsStatistics = true
        self.scnView?.backgroundColor = UIColor.black
        
        self.scnView?.scene = scene
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        
        self.area = SCNVector3(6, 6, 6)
        
        self.setupScene()
        
        self.iterating = false
        self.tapMode = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // self.iterating = false
        self.startCA()
        
        if self.scnView?.isPlaying != true {
            
            self.scnView?.play(nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // self.iterating = false
        self.gameOfLife3D = nil
        
        self.scnView?.stop(nil)
    }
    
    // MARK: Actions
    
    func positionFromIndex(index: Int) -> SCNVector3? {
        
        if let width = self.area?.x, let height = self.area?.y {
            
            // we need to find from the index, it's relative column/row/section
            // then, multiply z * section, y * row, x * column
            
            let section = index / (Int(width) * Int(height))
            let row = (index % (Int(width) * Int(height))) / Int(height)
            let column = (index % (Int(width) * Int(height))) % Int(height)
            
            return SCNVector3(column, row, section)
        }
        
        return nil
    }
    
    func emptyCubeHolder() {
     
        self.cubeHolder.childNodes.forEach { (node) in
            
            node.removeFromParentNode()
        }
    }
    
    func iterate(data: [UInt8]) {
        
        self.emptyCubeHolder()
        
        DispatchQueue.main.async {
            
            for index in 0..<data.count {
                
                let state = data[index]
                
                if state == 1, let position = self.positionFromIndex(index: index) {
                    
                    let newCube = Cube()
                    self.cubeHolder.addChildNode(newCube.node)
                    newCube.node.position = position
                }
            }
            
            self.gameOfLife3D?.updateStates(completion: { (data) in
                
                if self.iterating != true { return }
                self.iterate(data: data)
            })
        }
    }
    
    private func startCA() {
        
        if let width = self.area?.x, let height = self.area?.y, let depth = self.area?.z {
            
            self.gameOfLife3D = GameOfLife3D(width: Int(width), height: Int(height), depth: Int(depth))
        }
        
        if let cells = self.gameOfLife3D?.cells {
            
            self.iterate(data: cells)
        }
    }
    
    @IBAction
    private func toggleIteration(_ sender: Any) {
        
        if self.tapMode != true {
            
            self.iterating = self.iterating == true ? false : true
        }
        
        if let cells = self.gameOfLife3D?.cells {
            
            self.iterate(data: cells)
        }
    }
    
    @IBAction func resetCA(_ sender: Any) {
        
        self.startCA()
    }
}
