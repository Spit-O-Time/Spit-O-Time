//
//  GameScene.swift
//  SpitOTime
//
//  Created by Rodrigo Silva Ribeiro on 05/03/21.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let spit = Spit()
    
    let motionManager = CMMotionManager()
    
    let background = Background()

    lazy var sceneCamera: SKCameraNode = {
        let camera = SKCameraNode()
        camera.setScale(800)
        return camera
    }()
    
    override func didMove(to view: SKView) {
        // Camera
        motionManager.startAccelerometerUpdates()
        self.camera = sceneCamera
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        self.setupNodes()
    }
    
    func setupNodes() {
        guard let spitSpriteNode = spit
                .component(ofType: AnimatedSpriteComponent.self)?
                .shape else { return }
                
        spitSpriteNode.physicsBody?.allowsRotation = true
        spitSpriteNode.physicsBody?.restitution = 0.5
        addChild(spitSpriteNode)
        
        guard let backgrounds = background
                .component(ofType: AnimatedSpriteComponent.self)?
                .backgrounds else { return }
        addChild(backgrounds[0])
        addChild(backgrounds[1])
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8)
        }
        
        background.component(ofType: AnimatedSpriteComponent.self)?.updateBackground(cameraNode: sceneCamera)
    }
    
}
