//
//  GameScene.swift
//  SpitOTime
//
//  Created by Rodrigo Silva Ribeiro on 05/03/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    lazy var sceneCamera: SKCameraNode = {
        let camera = SKCameraNode()
        camera.setScale(3500)
        return camera
    }()
    
    override func didMove(to view: SKView) {
        // Camera
        self.camera = sceneCamera
        
        //Nodes
        
        //Gestures
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}
