//
//  SpitComponent.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita Coelho on 07/09/24.
//

import GameplayKit

class SpitComponent: GKComponent {
    
    let spriteNode: SKSpriteNode = SKSpriteNode()

    // Constants
    private let size = CGSize(width: 25, height: 25)
    private let physicsBody = SKPhysicsBody(circleOfRadius: 12.5)
    private let position = CGPoint(x: ScreenSize.width/2, y: .zero)
    private let density = CGFloat(12)
    private let categoryBitMask = CategoryMask.spit.rawValue
    private let collisionBitMask = CategoryMask.collides(bodyA: .spit, bodyB: .llama)

    override init() {
        spriteNode.size = size
        spriteNode.position = position
        spriteNode.physicsBody = physicsBody
        spriteNode.anchorPoint = CGPoint(x: size.width/2, y: size.height)
        spriteNode.physicsBody?.categoryBitMask = categoryBitMask
        spriteNode.physicsBody?.collisionBitMask = collisionBitMask
        spriteNode.physicsBody?.affectedByGravity = false
        spriteNode.physicsBody?.allowsRotation = false
        spriteNode.physicsBody?.restitution = .zero
        spriteNode.physicsBody?.density = density
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
