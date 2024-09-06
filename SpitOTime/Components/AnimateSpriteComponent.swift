//
//  AnimatedSpriteComponent.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 11/03/21.
//  All rights reserved DO NOT COPY THIS FILE

import Foundation
import GameplayKit
import SpriteKit

class AnimateSpriteComponent: GKComponent {

    public let spriteNode: SKSpriteNode
    private let categoryBitMask: UInt32
    private let collisionBitMask: UInt32
    private let size: CGSize

    var animationAtlas: SKTextureAtlas?
    var animationTextures: [SKTexture]?

    init(textureName: String, categoryBitMask: CategoryMask, collisionBitMask: UInt32, size: CGSize) {
        self.categoryBitMask = categoryBitMask.rawValue
        self.collisionBitMask = collisionBitMask
        self.spriteNode = SKSpriteNode(imageNamed: textureName)
        self.size = size
        
        // setup
        self.spriteNode.size = size
        self.spriteNode.position = CGPoint(x: ScreenSize.width/2, y: .zero)
        self.spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.spriteNode.anchorPoint = CGPoint(x: size.width/2, y: size.height)
        self.spriteNode.physicsBody?.categoryBitMask = categoryBitMask.rawValue
        self.spriteNode.physicsBody?.collisionBitMask = collisionBitMask
        self.spriteNode.physicsBody?.affectedByGravity = false
        self.spriteNode.physicsBody?.allowsRotation = false
        self.spriteNode.physicsBody?.restitution = 0
        self.spriteNode.physicsBody?.density = 12
        
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAnimation(atlasName: String) {
        guard let textures = animationTextures else {
            return
        }

        self.spriteNode.removeAllActions()
        self.animationAtlas = SKTextureAtlas(named: atlasName)
        self.spriteNode.texture = textures.first

        self.spriteNode.run(
                SKAction.animate(
                    with: textures,
                    timePerFrame: 0.1,
                    resize: false,
                    restore: true
                ),
            withKey: atlasName
        )
    }
}
