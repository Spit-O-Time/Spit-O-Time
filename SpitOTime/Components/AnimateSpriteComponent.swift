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

    var spriteNode: SKSpriteNode!
    
    var animationAtlas: SKTextureAtlas?
    var animationTextures: [SKTexture] {
        animationAtlas?.textureNames.compactMap { textureName in animationAtlas?.textureNamed(textureName) } ?? []
    }

    init(textureName: String) {
        super.init()
        self.spriteNode = SKSpriteNode(imageNamed: textureName)
    }

    init(atlasName: String) {
        super.init()

        self.animationAtlas = SKTextureAtlas(named: atlasName)
        self.spriteNode = SKSpriteNode(imageNamed: animationAtlas!.textureNames.first!)
        self.spriteNode.texture = animationTextures.first!
//        self.spriteNode.position = CGPoint(x: ScreenSize.width/2, y: 0)
        self.spriteNode.physicsBody = SKPhysicsBody(circleOfRadius: self.spriteNode.size.width/2)
        self.spriteNode.anchorPoint = CGPoint(x: self.spriteNode.size.width/2, y: self.spriteNode.size.height)
        self.spriteNode.physicsBody?.categoryBitMask = CategoryMask.spit.rawValue
        self.spriteNode.physicsBody?.collisionBitMask = CategoryMask.obstacle.rawValue | CategoryMask.spit.rawValue
        self.spriteNode.physicsBody?.affectedByGravity = false
        self.spriteNode.physicsBody?.allowsRotation = false
        self.spriteNode.physicsBody?.restitution = 0
        self.spriteNode.physicsBody?.density = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setAnimation(atlasName: String) {
        spriteNode.removeAllActions()

        self.animationAtlas = SKTextureAtlas(named: atlasName)
        self.spriteNode.texture = animationTextures.first!

        spriteNode.run(
                SKAction.animate(
                    with: animationTextures,
                    timePerFrame: 0.1,
                    resize: false,
                    restore: true
                ),
            withKey: atlasName
        )
    }
}
