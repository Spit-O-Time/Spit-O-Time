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
        camera.setScale(1)
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
        // Spit
        guard let spitSpriteNode = spit
                .component(ofType: AnimatedSpriteComponent.self)?
                .shape else { return }
                
        spitSpriteNode.physicsBody?.allowsRotation = true
        spitSpriteNode.physicsBody?.restitution = 0.5
        addChild(spitSpriteNode)
        
        // Ground and Walls
        addBackgroundsAndWalls()
    }
    
    func addBackgroundsAndWalls() {
        guard let backgrounds = background
                .component(ofType: AnimatedSpriteComponent.self) else { return }
              
          let ground = backgrounds.grounds
          let leftWall = backgrounds.wallLeft
          let rightWall = backgrounds.wallRight
        
        ground.forEach { addChild($0) }
        leftWall.forEach { addChild($0) }
        rightWall.forEach { addChild($0) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: accelerometerData.acceleration.y * 9.8)
        }
        
        self.camera?.position.y += 5
        background.component(ofType: AnimatedSpriteComponent.self)?
                    .updateBackground(cameraNode: sceneCamera)
    }
    
}
