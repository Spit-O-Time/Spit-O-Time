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
    
    // MARK: Variables
    let spit = Spit()
    var spitTail: SKEmitterNode?
    
    let background = Background()
    
    let obstacle = Obstacle()
    var obstacles = [SKSpriteNode]()
    
    var startGame = false
    let motionManager = CMMotionManager()
    
    lazy var sceneCamera: SKCameraNode = {
        let camera = SKCameraNode()
        camera.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2)
        return camera
    }()
    
    // MARK: Sounds
    var backgroundSound: SKAudioNode!
    var llamaSpit: SKAudioNode!
    var gameOverSound: SKAudioNode!
    
    // MARK: DidMove
    override func didMove(to view: SKView) {
        scheduleTimer()
        spawnObstacles()
        setupNodes()
        
        backgroundSound = AudioManager().getSKAudioNode(name: .background)
        addChild(backgroundSound)
        
        self.camera = sceneCamera
        self.physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    // MARK: Time events
    func scheduleTimer() {
        Timer.scheduledTimer(timeInterval: 3,
                             target: self,
                             selector: #selector(timerTrigger),
                             userInfo: nil,
                             repeats:  false)
    }
    
    func spawnObstacles() {
        let wait = SKAction.wait(forDuration: 3, withRange: 2)
        let spawn = SKAction.run {
            guard let llama = self.obstacle
                    .component(ofType: SpawnComponent.self)?.spawn() else { return }
            llama.physicsBody?.categoryBitMask = CategoryMask.obstacle.rawValue
            llama.physicsBody?.contactTestBitMask = CategoryMask.spit.rawValue
            if llama.parent == nil {
                self.addChild(llama)
            }
            self.obstacles.append(llama)
        }

        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
        removeObstacles()
    }
    
    func removeObstacles() {
        obstacles.enumerated().forEach { (index, obstacle) in
            if obstacle.position.y < -obstacle.frame.height {
                guard obstacles.indices.contains(index) else { return }
                obstacles.remove(at: index)
                obstacle.removeFromParent()
            }
        }
    }
    
    @objc func timerTrigger() {
        startGame = true
        llamaSpit = AudioManager().getSKAudioNode(name: .spit)
        addChild(llamaSpit)
        spit.component(ofType: AnimateSpriteComponent.self)!.setAnimation(atlasName: "SpitAtlas")
    }
    
    // MARK: Setup Sprites
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
        spitSpriteNode.physicsBody?.categoryBitMask = CategoryMask.spit.rawValue
        spitSpriteNode.physicsBody?.collisionBitMask = CategoryMask.obstacle.rawValue | CategoryMask.spit.rawValue
        spitSpriteNode.physicsBody?.affectedByGravity = false
        spitSpriteNode.physicsBody?.allowsRotation = false
        spitSpriteNode.physicsBody?.restitution = 0
        spitSpriteNode.physicsBody?.density = 12
        
        spitTail = SKEmitterNode(fileNamed: "MyParticle.sks")!
        spitTail?.position = spitSpriteNode.position
        addChild(spitTail!)
        
        addChild(spitSpriteNode)
    }
    
    // MARK: Movimentation
    func animateSpit() {
        let spitPosition =  spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position
        spitTail?.position = spitPosition
        
        if let accelerometerData = motionManager.accelerometerData {
            spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position.x += CGFloat(accelerometerData.acceleration.x) * 16
        }
        
        if spitPosition.y < sceneCamera.position.y/2 {
            spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position.y += 10
        }
    }
    
    func animateBackground() {
        guard let backgoundComponent = background
                .component(ofType: AnimateBackgroundComponent.self) else { return }
        
        backgoundComponent.updateBackground(cameraNode: sceneCamera)
    }
    
    // MARK: Begin Contact
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == CategoryMask.spit.rawValue | CategoryMask.obstacle.rawValue {
            gameOver()
        }
        
    }

    // MARK: Game Over
    func gameOver() {
        self.view?.isPaused = true
        AudioManager().stopSKAudioNode(audioNode: backgroundSound)
        AudioManager().stopSKAudioNode(audioNode: gameOverSound)
    }
    
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        guard startGame else { return }
        
        animateSpit()
        animateBackground()
        removeObstacles()
        
        for obstacle in obstacles {
            obstacle.position.y -= 8
        }
        
    }
    
}
