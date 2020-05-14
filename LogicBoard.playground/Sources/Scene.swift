//
//  Scene.swift
//  Book_Sources
//
//  Created by Oksana Bolibok on 3/22/19.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    private var boardAdded: Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if boardAdded {
            return
        }
        
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -1.5
            
            let transform = simd_mul(currentFrame.camera.transform, translation)
            let anchor = ARAnchor(name: Constant.boardAncherName, transform: transform)
            
            sceneView.session.add(anchor: anchor)
            boardAdded = true
        }
    }
}

