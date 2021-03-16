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
    
    var startGame = false
    
    lazy var sceneCamera: SKCameraNode = {
        let camera = SKCameraNode()
        camera.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2)
        return camera
    }()
    
    override func didMove(to view: SKView) {
        motionManager.startAccelerometerUpdates()
        self.camera = sceneCamera
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.setupNodes()
        
        Timer.scheduledTimer(timeInterval: 3,
                             target: self,
                             selector: #selector(timerTrigger),
                             userInfo: nil,
                             repeats:  false)
        
    }
    
    @objc func timerTrigger() {
        startGame = true
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
        let llama = backgrounds.llama
        
        addChild(llama)
        ground.forEach { addChild($0) }
        leftWall.forEach { addChild($0) }
        rightWall.forEach { addChild($0) }
    }
    
    func addSpit() {
        guard let spitSpriteNode = spit
                .component(ofType: AnimateSpriteComponent.self)?
                .spriteNode else { return }
        spitSpriteNode.position = CGPoint(x: ScreenSize.width/2, y: 0)
        spitSpriteNode.size = CGSize(width: 40, height: 40)
        spitSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: spitSpriteNode.size.width/2)
        spitSpriteNode.physicsBody?.affectedByGravity = false
        spitSpriteNode.physicsBody?.allowsRotation = false
        spitSpriteNode.physicsBody?.restitution = 0
        spitSpriteNode.physicsBody?.density = 12
        addChild(spitSpriteNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard startGame else {return}
        let spitPosition =  spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position
        
        
        if let accelerometerData = motionManager.accelerometerData {
            spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position.x += CGFloat(accelerometerData.acceleration.x) * 9.8
        }
        
        if spitPosition.y < sceneCamera.position.y {
            spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position.y += 10
        }
        
        background.component(ofType: AnimateBackgroundComponent.self)?
            .updateBackground(cameraNode: sceneCamera)
    }
    
}
