//
//  Cube.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 9/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import SceneKit

protocol CubeProtocol {
    
    var node: SCNNode { get }
}

struct Cube {
    
    public var node: SCNNode
    
    init() {
        
        let boxGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor.gray
        boxMaterial.lightingModel = .phong
        boxGeometry.firstMaterial = boxMaterial
        
        self.node = SCNNode(geometry: boxGeometry)
        
        self.node.castsShadow = true
    }
}
