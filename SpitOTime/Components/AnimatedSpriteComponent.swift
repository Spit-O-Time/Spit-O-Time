//
//  AnimatedSpriteComponent.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 11/03/21.
//  All rights reserved DO NOT COPY THIS FILE

import Foundation
import GameplayKit
import SpriteKit

class AnimatedSpriteComponent: GKComponent {

    var spriteNode: SKSpriteNode! //spit
    var shape: SKShapeNode! //spit teste
    var backgrounds: [SKSpriteNode] {
        let firstBackground = SKSpriteNode(imageNamed: "ground")
        let secondBackground = SKSpriteNode(imageNamed: "ground")
        
        return [firstBackground, secondBackground]
    }
    
    var wallLeft = SKSpriteNode(imageNamed: "wallLeft")
    
    var wallRight = SKSpriteNode(imageNamed: "wallRight")
    
    
    var animationAtlas: SKTextureAtlas?
    var animationTextures: [SKTexture] {
        animationAtlas?.textureNames.compactMap { textureName in animationAtlas?.textureNamed(textureName) } ?? []
    }
    
    override init() {
        super.init()
        shape = SKShapeNode(circleOfRadius: 250)
        shape.physicsBody = SKPhysicsBody(circleOfRadius: 250)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateBackground(cameraNode: SKCameraNode) {
        if (cameraNode.position.y > backgrounds[0].position.y + backgrounds[0].size.height + 400) {
            backgrounds[0].position = CGPoint(x: backgrounds[0].position.y , y: backgrounds[1].position.x + backgrounds[1].size.height)
        }
        
        if (cameraNode.position.y > backgrounds[1].position.y + backgrounds[1].size.height + 400) {
            backgrounds[1].position = CGPoint(x: backgrounds[1].position.y , y: backgrounds[0].position.x + backgrounds[0].size.height)
        }
    }

    func setAnimation(atlasName: String) {
        spriteNode.removeAllActions()

        self.animationAtlas = SKTextureAtlas(named: atlasName)
        self.spriteNode.texture = animationTextures.first!

        spriteNode.run(
            SKAction.repeatForever(
                SKAction.animate(
                    with: animationTextures,
                    timePerFrame: 0.1,
                    resize: false,
                    restore: true
                )
            ),
            withKey: atlasName
        )
    }
}
