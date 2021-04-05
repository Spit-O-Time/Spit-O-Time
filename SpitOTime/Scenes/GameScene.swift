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
    var spitTail: SKEmitterNode!
    
    let background = Background()
    
    let obstacle = Obstacle()
    var obstacles = [SKSpriteNode]()
    
    var isPlaying = false
    let motionManager = CMMotionManager()
    
    var stateMachine: GameStateMachine?
    
    var difficulty: CGFloat = 6
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)";
        }
    }
    
    var scoreCount: Float = 0
    
    lazy var sceneCamera: SKCameraNode = {
        let camera = SKCameraNode()
        camera.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2)
        return camera
    }()
    
    // MARK: Sounds
    var backgroundSound: SKAudioNode!
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
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    // MARK: Time events
    func scheduleTimer() {
        Timer.scheduledTimer(timeInterval: 4,
                             target: self,
                             selector: #selector(timerTrigger),
                             userInfo: nil,
                             repeats:  false)
    }
    
    func difficultyTimer() {
        Timer.scheduledTimer(timeInterval: 3,
                             target: self,
                             selector: #selector(difficultyTrigger),
                             userInfo: nil,
                             repeats: true)
        
    }
    
    @objc func difficultyTrigger() {
        if isPlaying {
            difficulty += 0.2 
        }
    }
    
    func scoreTimer() {
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(self.scorePoints),
                             userInfo: nil,
                             repeats:  true)
    }
    
    @objc func scorePoints() {
        guard isPlaying else { return }
        if scoreCount > 5 {
            score += Int(difficulty)
        } else {
            score = Int(powf(2, scoreCount))
        }
        scoreCount += 1
    }
    
    func spawnObstacles() {
        let wait = SKAction.wait(forDuration: 3, withRange: 2)
        let spawn = SKAction.run {
            guard let llama = self.obstacle
                    .component(ofType: SpawnComponent.self)?.spawn() else { return }
            if llama.parent == nil {
                self.addChild(llama)
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
            addChild(backgroundSound)
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
        
        addChild(llama)
        ground.forEach { addChild($0) }
        leftWall.forEach { addChild($0) }
        rightWall.forEach { addChild($0) }
    }
    
    func addSpit() {
        guard let spitSpriteNode = spit
                .component(ofType: AnimateSpriteComponent.self)?
                .spriteNode else { return }
        
        if let spitTail = SKEmitterNode(fileNamed: "SpitParticle.sks") {
            self.spitTail = spitTail
            self.spitTail.position = spitSpriteNode.position
            addChild(self.spitTail)
        }
        
        addChild(spitSpriteNode)
    }
    
    func setUpText() {
        scoreLabel = SKLabelNode(fontNamed: "Orange Slices")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = .cardBackgroundColor
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height - 70)
        print(scoreLabel.position)
        self.addChild(scoreLabel)
    }
    
    // MARK: Movimentation
    func animateSpit() {
        let spitPosition =  spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position
        spitTail?.position = spitPosition
        
        if let accelerometerData = motionManager.accelerometerData {
            spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position.x += CGFloat(accelerometerData.acceleration.x) * (8 + difficulty)
        }
        
        if spitPosition.y < sceneCamera.position.y/2 {
            spit.component(ofType: AnimateSpriteComponent.self)!.spriteNode.position.y += 10
        }
    }
    
    func animateBackground() {
        guard let backgoundComponent = background
                .component(ofType: AnimateBackgroundComponent.self) else { return }
        
        backgoundComponent.updateBackground(cameraNode: sceneCamera, velocity: difficulty)
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
        self.score = 0
        self.scoreCount = 0
        self.view?.isPaused = true
        stateMachine?.enter(GameOverState.self)
        audioManager.stopSKAudioNode(backgroundSound)
    }
    
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        guard isPlaying else { return }
        animateSpit()
        animateBackground()
        removeObstacles()
        for obstacle in obstacles {
            obstacle.position.y -= difficulty
        }
    }
    
}
