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
    
    // MARK: - Nodes
    let worldNode = SKNode()
    let spit = Spit()
    let background = Background()
    let obstacle = Obstacle()
    var obstacles = [SKSpriteNode]()

    var spitTail: SKEmitterNode!
    var scoreLabel: SKLabelNode!
    
    // MARK: - Variables
    var isPlaying = false
    var isRunningAnimationCount = false
    var velocity: CGFloat = 8
    var score: Int = 0
    var secondsOfPlaying: Float = 0


    // MARK: Managers
    var stateMachine: GameStateMachine?
    let motionManager = CMMotionManager()
    
    // MARK: Camera
    lazy var sceneCamera: SKCameraNode = {
        let camera = SKCameraNode()
        camera.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2)
        return camera
    }()
    
    // MARK: Sounds
    var backgroundSound: SKAudioNode!
    var backgroundLoop: SKAudioNode!
    var llamaSpit: SKAudioNode!
    var gameOverSound: SKAudioNode!
    
    var audioManager = AudioManager()
    
    // MARK: DidMove
    override func didMove(to view: SKView) {
        scheduleTimer()
        difficultyTimer()
        scoreTimer()
        spawnObstacles()
        setupNodes()
        setUpText()
        addBackgroundSound()
        self.camera = sceneCamera
        self.physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
        stateMachine?.enter(PlayingState.self)
        addChild(worldNode)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    // MARK: Time events
    func scheduleTimer() {
        Timer.scheduledTimer(
            timeInterval: 4,
            target: self,
            selector: #selector(timerTrigger),
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
    
    @objc func difficultyTrigger() {
        if isPlaying {
            velocity += 0.5
        }
    }
    
    func scoreTimer() {
        Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateScorePoints),
            userInfo: nil,
            repeats:  true
        )
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
    
    func spawnObstacles() {
        let wait = SKAction.wait(forDuration: 3, withRange: 2)
        let spawn = SKAction.run {
            guard let llama = self.obstacle
                    .component(ofType: SpawnComponent.self)?.spawn() else { return }
            if llama.parent == nil {
                self.worldNode.addChild(llama)
                self.obstacles.append(llama)
            }
        }
        
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
        removeObstacles()
    }
    
    func removeObstacles() {
        for (index, obstacle) in obstacles.enumerated() {
            if obstacle.position.y < -obstacle.frame.height {
                guard obstacles.indices.contains(index) else { return }
                print(obstacle.position.y)
                obstacles.remove(at: index)
                obstacle.removeFromParent()
            }
        }
    }
    
    func addBackgroundSound() {
        
        if let backgroundSound = audioManager.getSKAudioNode(.background) {
            self.backgroundSound = backgroundSound
            self.worldNode.addChild(backgroundSound)
            let sequence = SKAction.sequence( [SKAction.play(), SKAction.wait(forDuration: 4.0 ) ])
            backgroundSound.run(SKAction.changeVolume(to: Float(0.5), duration: 0))
            run(sequence, completion: {
                guard let backgroundLoop = self.audioManager.getSKAudioNode(.backgroundLoop) else { return }
                backgroundSound.removeFromParent()
                self.worldNode.addChild(backgroundLoop)
                backgroundLoop.run(SKAction.changeVolume(to: Float(0.5), duration: 0))
            })
        }
    }
    
    @objc func timerTrigger() {
        isPlaying = true
        if let spitComponent = spit.component(ofType: AnimateSpriteComponent.self) {
            guard let sound = audioManager.playSKAudioNode(.spit) else { return }
            spitComponent.spriteNode.run(sound)
        }
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
        let llama = backgrounds.shooterCharacter
        
        self.worldNode.addChild(llama)
        ground.forEach { self.worldNode.addChild($0) }
        leftWall.forEach { self.worldNode.addChild($0) }
        rightWall.forEach { self.worldNode.addChild($0) }
    }
    
    func addSpit() {
        guard let spitSpriteNode = spit
                .component(ofType: AnimateSpriteComponent.self)?
                .spriteNode else { return }
        
        if let spitTail = SKEmitterNode(fileNamed: "SpitParticle.sks") {
            self.spitTail = spitTail
            self.spitTail.position = spitSpriteNode.position
            self.worldNode.addChild(self.spitTail)
        }
        
        self.worldNode.addChild(spitSpriteNode)
    }
    
    func setUpText() {
        scoreLabel = SKLabelNode(fontNamed: "Orange Slices")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = .cardBackgroundColor
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height - 70)
        print(scoreLabel.position)
        self.worldNode.addChild(scoreLabel)
    }
    
    // MARK: Movimentation
    func animateSpit() {
        let spitPosition =  spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position
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
        }
        
    }
    
    // MARK: Game Over
    func gameOver() {
        stateMachine?.enter(GameOverState.self)
        audioManager.stopSKAudioNode(backgroundSound)
    }
    
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        guard isPlaying else { return }
        scoreLabel.text = "Score: \(score)"
        animateSpit()
        animateBackground()
        removeObstacles()
        for obstacle in obstacles {
            obstacle.position.y -= velocity
        }
    }
    
}
