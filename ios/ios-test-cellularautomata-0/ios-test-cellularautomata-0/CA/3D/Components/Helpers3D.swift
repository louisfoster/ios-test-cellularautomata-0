//
//  File.swift
//  ios-test-level-map-1
//
//  Created by Louie on 10/3/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import UIKit
import SceneKit

func createDiffuseCubeObject(color: UIColor, size: CGFloat) -> SCNNode {
    
    return SCNNode(geometry: createDiffuseCubeGeometry(color: color, size: size))
}

func createDiffuseCubeGeometry(color: UIColor, size: CGFloat) -> SCNBox {
    
    let boxGeometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
    let boxMaterial = SCNMaterial()
    boxMaterial.diffuse.contents = color
    boxGeometry.firstMaterial = boxMaterial
    
    return boxGeometry
}
