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
    var spitTail: SKEmitterNode?
    
    let motionManager = CMMotionManager()
    
    let background = Background()
    let obstacle = Obstacle()
    
    var obstacles = [SKSpriteNode]()
    
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

        

        let wait = SKAction.wait(forDuration: 3, withRange: 2)
        let spawn = SKAction.run {
            guard let llama = self.obstacle
                    .component(ofType: SpawnComponent.self)?.spawn() else { return }
            if llama.parent == nil {
                self.addChild(llama)
            }
            self.obstacles.append(llama)
        }

        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    @objc func timerTrigger() {
        startGame = true
        spit.component(ofType: AnimateSpriteComponent.self)!.setAnimation(atlasName: "SpitAtlas")
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
        spitSpriteNode.physicsBody = SKPhysicsBody(circleOfRadius: spitSpriteNode.size.width/2)
        spitSpriteNode.anchorPoint = CGPoint(x: spitSpriteNode.size.width/2, y: spitSpriteNode.size.height)
        spitSpriteNode.physicsBody?.affectedByGravity = false
        spitSpriteNode.zPosition = 1
        spitSpriteNode.physicsBody?.allowsRotation = false
        spitSpriteNode.physicsBody?.restitution = 0
        spitSpriteNode.physicsBody?.density = 12
        
        spitTail = SKEmitterNode(fileNamed: "SpitParticle.sks")!
        spitTail?.position = spitSpriteNode.position
        spitTail?.zPosition = -1
        addChild(spitTail!)
        
        addChild(spitSpriteNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard startGame else {return}
        let spitPosition =  spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position
        spitTail?.position = spitPosition
        
        if let accelerometerData = motionManager.accelerometerData {
            spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position.x += CGFloat(accelerometerData.acceleration.x) * 9.8
        }
        
        if spitPosition.y < sceneCamera.position.y {
            spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position.y += 10
        }
        
        background.component(ofType: AnimateBackgroundComponent.self)?
            .updateBackground(cameraNode: sceneCamera)
        
        
        obstacles.forEach { $0.position.y -= 5 }
        
        if spitPosition.y < -10 {
            print("Game over")
        }
    }
    
}
