//
//  GameScene.swift
//  SpitOTime
//
//  Created by Rodrigo Silva Ribeiro on 05/03/21.
//

import SpriteKit
import GameplayKit
import CoreMotion
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Nodes
    let spit = Spit()
    let background = Background()
    let obstacle = Obstacle()
    var llamas = [SKSpriteNode]()

    var spitTail: SKEmitterNode!
    var scoreLabel: SKLabelNode!
    
    // MARK: - Variables
    var isPlaying = false
    var velocity: CGFloat = 8
    var score: Int = 0
    var secondsOfPlaying: Float = 0

    // MARK: Managers
    var stateMachine: GKStateMachine?
    let motionManager = CMMotionManager()
    
    // MARK: Camera
    lazy var sceneCamera: SKCameraNode = {
        let camera = SKCameraNode()
        camera.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2)
        return camera
    }()

    override func didMove(to view: SKView) {
        startGameTimer()
        difficultyTimer()
        updateScoreTimer()
        spawnLlamas()
        setupNodes()

        self.camera = sceneCamera
        self.physicsWorld.contactDelegate = self
        self.motionManager.startAccelerometerUpdates()
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    // MARK: Time events
    func startGameTimer() {
        Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(startGameTrigger),
            userInfo: nil,
            repeats:  false
        )
    }
    
    func difficultyTimer() {
        Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(difficultyTrigger),
            userInfo: nil,
            repeats: true
        )
    }
    
    func updateScoreTimer() {
        Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateScorePoints),
            userInfo: nil,
            repeats:  true
        )
    }
    
    // MARK: Triggers
    @objc func startGameTrigger() {
        guard !isPaused else { return }
        self.isPlaying = true
        self.stateMachine?.enter(PlayingState.self)
        let playSpitSound = SKAction.playSoundFileNamed(
            Assets.Sound.spit.rawValue, waitForCompletion: false
        )
        let spitNode = spit.component(ofType: AnimateSpriteComponent.self)?.spriteNode
        spitNode?.run(playSpitSound)
    }
    
    @objc func updateScorePoints() {
        guard isPlaying else { return }
        
        if secondsOfPlaying > 5 {
            score += Int(secondsOfPlaying * 1.5)
        } else {
            score = Int(powf(2, secondsOfPlaying))
        }
        secondsOfPlaying += 1
    }

    @objc func difficultyTrigger() {
        if isPlaying {
            velocity += 0.5
        }
    }

    func spawnLlamas() {
        let wait = SKAction.wait(forDuration: 3, withRange: 2)
        let spawn = SKAction.run {
            guard let llama = self.obstacle
                    .component(ofType: SpawnComponent.self)?.spawn() else { return }
            if llama.parent == nil {
                self.addChild(llama)
                self.llamas.append(llama)
            }
        }
        
        let sequence = SKAction.sequence([wait, spawn])
        run(SKAction.repeatForever(sequence))
        removeLlamas()
    }
    
    func removeLlamas() {
        for (index, llama) in llamas.enumerated() {
            if llama.position.y < -llama.frame.height {
                guard llamas.indices.contains(index) else { return }
                llamas.remove(at: index)
                llama.removeFromParent()
            }
        }
    }
    
    // MARK: Setup Sprites
    func setupNodes() {
        setupTextLabelNode()
        setupBackgroundNode()
        setupSpitNode()
    }
    
    func setupBackgroundNode() {
        guard let backgrounds = background.component(ofType: AnimateBackgroundComponent.self) else {
            return
        }
        
        let ground = backgrounds.grounds
        let leftWall = backgrounds.wallLeft
        let rightWall = backgrounds.wallRight
        let llama = backgrounds.shooterCharacter
        
        addChild(llama)
        ground.forEach { addChild($0) }
        leftWall.forEach { addChild($0) }
        rightWall.forEach { addChild($0) }
    }
    
    func setupSpitNode() {
        guard let spitSpriteNode = spit
            .component(ofType: AnimateSpriteComponent.self)?
            .spriteNode else { return }

        self.spitTail = SKEmitterNode(fileNamed: "SpitParticle.sks")
        self.spitTail.position = spitSpriteNode.position
        addChild(self.spitTail)

        addChild(spitSpriteNode)
    }
    
    func setupTextLabelNode() {
        scoreLabel = SKLabelNode(fontNamed: "Orange Slices")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = .cardBackgroundColor
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height - 120)
        addChild(scoreLabel)
    }
    
    // MARK: Movimentation
    func animateSpit() {
        let spitPosition = spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position
        spitTail?.position = spitPosition
        
        if let accelerometerData = motionManager.accelerometerData {
            spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position.x += CGFloat(accelerometerData.acceleration.x) * (8 + velocity)
        }
        
        if spitPosition.y < sceneCamera.position.y/2 {
            spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position.y += 10
        }
    }
    
    func animateBackground() {
        guard let backgoundComponent = background
                .component(ofType: AnimateBackgroundComponent.self) else { return }
        
        backgoundComponent.updateBackground(cameraNode: sceneCamera, velocity: velocity)
    }
    
    // MARK: Begin Contact
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == CategoryMask.spit.rawValue | CategoryMask.obstacle.rawValue {
            gameOver()
            contact.bodyA.node?.removeFromParent()
            spitTail.removeFromParent()
        }
        
    }
        
    // MARK: Game Over
    func gameOver() {
        stateMachine?.enter(GameOverState.self)
    }
    
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        guard isPlaying else { return }
        scoreLabel.text = "Score: \(score)"
        animateSpit()
        animateBackground()
        removeLlamas()
        for llama in llamas {
            llama.position.y -= velocity
        }
    }
    
}
