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

class GameScene: SKScene {
    
    // MARK: - Nodes
    let spit = Spit()
    let background = Background()
    var llamas = [SKSpriteNode]()

    var spitTail: SKEmitterNode!
    var scoreLabel: SKLabelNode!
    
    // MARK: - Variables
    var isPlaying = false
    var velocity: CGFloat = 8
    var maxVelocity: CGFloat = 15
    var score: Int = 0
    var secondsOfPlaying: Int = 0

    // MARK: Managers
    var stateMachine: GKStateMachine?
    let motionManager = CMMotionManager()
    
    // MARK: Camera
    lazy var sceneCamera: SKCameraNode = {
        let camera = SKCameraNode()
        camera.position = ScreenPosition.center
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
    
    override func update(_ currentTime: TimeInterval) {
        guard isPlaying else { return }
        scoreLabel.text = "Score: \(score)"
        animateSpit()
        animateBackground()
        removeLlamas()
        animateLlamas()
    }

    func spawnLlamas() {
        let wait = SKAction.wait(forDuration: 3, withRange: 2)
        let spawn = SKAction.run {
            guard let llama = Llama().component(ofType: SpawnComponent.self)?.spawn() else { return }
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

    func animateLlamas() {
        for llama in llamas {
            llama.position.y -= velocity
        }
    }
    
    func animateSpit() {
        guard let spitNode = spit.component(ofType: SpitComponent.self)?.spriteNode
        else { return }
        spitTail?.position = spitNode.position

        if let accelerometerData = motionManager.accelerometerData {
            let accelerometerX = CGFloat(accelerometerData.acceleration.x)
            spitNode.position.x += accelerometerX * velocity
        }

        if spitNode.position.y < sceneCamera.position.y/2 {
            spitNode.position.y += 10
        }
    }

    func animateBackground() {
        guard let backgoundComponent = background
                .component(ofType: AnimateBackgroundComponent.self) else { return }
        
        backgoundComponent.updateBackground(cameraNode: sceneCamera, velocity: velocity)
    }

    // MARK: Game Over
    func gameOver() {
        stateMachine?.enter(GameOverState.self)
    }
    
}

// MARK: Contact
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if collision == CategoryMask.collides(bodyA: .spit, bodyB: .llama) {
            gameOver()
            contact.bodyA.node?.removeFromParent()
            spitTail.removeFromParent()
        }
    }
    
}
