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
        return camera
    }()
    
    override func didMove(to view: SKView) {
        motionManager.startAccelerometerUpdates()
        self.camera = sceneCamera
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.setupNodes()

    }
    
    func setupNodes() {
        addSpit()
        addBackgroundsAndWalls()
    }
    
    func addBackgroundsAndWalls() {
        guard let backgrounds = background
                .component(ofType: AnimateBackgroundComponent.self) else { return }
              
          let ground = backgrounds.grounds
          let leftWall = backgrounds.wallLeft
          let rightWall = backgrounds.wallRight
        
        ground.forEach { addChild($0) }
        leftWall.forEach { addChild($0) }
        rightWall.forEach { addChild($0) }
    }
    
    func addSpit() {
        guard let spitSpriteNode = spit
                .component(ofType: AnimateSpriteComponent.self)?
                .spriteNode else { return }
        spitSpriteNode.position = CGPoint(x: 50, y: 50)
        spitSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: spitSpriteNode.size.width*2)
        spitSpriteNode.size = CGSize(width: 120, height: 120)
        spitSpriteNode.physicsBody?.allowsRotation = false
        spitSpriteNode.physicsBody?.restitution = 0
        spitSpriteNode.physicsBody?.density = 12
        addChild(spitSpriteNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let spitPosition =  spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position
        self.sceneCamera.position = CGPoint(x: self.frame.midX, y: spitPosition.y)
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 9.8, dy: (accelerometerData.acceleration.y * 9.8) * -1)
        }
        
        self.camera?.position.y += 5
        background.component(ofType: AnimateBackgroundComponent.self)?
                    .updateBackground(cameraNode: sceneCamera)
    }
    
}
