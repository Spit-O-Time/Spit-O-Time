//
//  SpawnComponent.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 16/03/21.
//

import GameplayKit
import SpriteKit

class SpawnComponent: GKComponent {

    var sprites: [String]

    private let size: CGSize
    private let physicsBody: SKPhysicsBody
    private let categoryBitMask: UInt32
    private let contactTestBitMask: UInt32

    private let marginSpawnAreaLeft: CGFloat = SKSpriteNode(imageNamed: "wallLeft").size.width / 2
    private let marginSpawnAreaRight: CGFloat = SKSpriteNode(imageNamed: "wallRight").size.width / 2

    init(sprites: [String], size: CGSize, physicsBody: SKPhysicsBody, categoryBitMask: CategoryMask, contactTestBitMask: CategoryMask) {
        self.sprites = sprites
        self.size = size
        self.physicsBody = physicsBody
        self.categoryBitMask = categoryBitMask.rawValue
        self.contactTestBitMask = contactTestBitMask.rawValue
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func spawn() -> SKSpriteNode {
        let randomSpriteNode = SKSpriteNode(imageNamed: sprites.randomElement() ?? String())
        randomSpriteNode.zPosition = 0
        randomSpriteNode.size = size

        randomSpriteNode.physicsBody = physicsBody
        randomSpriteNode.physicsBody?.categoryBitMask = categoryBitMask
        randomSpriteNode.physicsBody?.contactTestBitMask = contactTestBitMask
        randomSpriteNode.physicsBody?.affectedByGravity = false
        randomSpriteNode.physicsBody?.isDynamic = false
        randomSpriteNode.physicsBody?.allowsRotation = false
        
        let randomPosition = setupRandomPosition()
        randomSpriteNode.position = randomPosition
        return randomSpriteNode
    }

    private func setupRandomPosition() -> CGPoint {
        let spawnAreaRight = ScreenSize.width - size.width/2 - marginSpawnAreaRight
        let spawnAreaLeft = size.width/2 + marginSpawnAreaLeft
        return CGPoint(
            x: CGFloat.random(in: spawnAreaLeft...spawnAreaRight),
            y: ScreenSize.height + CGFloat.random(in: 0...ScreenSize.height)
        )
    }
    
}
