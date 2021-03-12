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
    
    var grounds: [SKSpriteNode] = {
        let firstBackground = SKSpriteNode(imageNamed: "ground")
        firstBackground.position = .zero
        firstBackground.zPosition = -1
        let secondBackground = SKSpriteNode(imageNamed: "ground")
        secondBackground.position.y = firstBackground.frame.height
        secondBackground.zPosition = -1
        return [firstBackground, secondBackground]
    }()
    var wallLeft: [SKSpriteNode] = {
        let wall1 = SKSpriteNode(imageNamed: "wallLeft")
        wall1.position = .zero
        let wall2 = SKSpriteNode(imageNamed: "wallLeft")
        wall2.position.y = wall1.frame.height
        return [wall1, wall2]
    }()
    var wallRight: [SKSpriteNode] = {
        let wall1 = SKSpriteNode(imageNamed: "wallRight")
        wall1.position = .zero
        let wall2 = SKSpriteNode(imageNamed: "wallRight")
        wall2.position.y = wall1.frame.height
        
        return [wall1, wall2]
    }()
    
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateBackground(cameraNode: SKCameraNode) {
        if (cameraNode.position.y > grounds[0].position.y + grounds[0].size.height) {
            grounds[0].position.y = grounds[1].position.y + grounds[1].size.height
        }
        
        if (cameraNode.position.y > grounds[1].position.y + grounds[1].size.height) {
            grounds[1].position.y = grounds[0].position.y + grounds[0].size.height
        }
        
        if (cameraNode.position.y > wallLeft[0].position.y + wallLeft[0].size.height) {
            wallLeft[0].position.y = wallLeft[1].position.y + wallLeft[1].size.height
        }
        
        if (cameraNode.position.y > wallLeft[1].position.y + wallLeft[1].size.height) {
            wallLeft[1].position.y = wallLeft[0].position.y + wallLeft[0].size.height
        }
        
        if (cameraNode.position.y > wallRight[0].position.y + wallRight[0].size.height) {
            wallRight[0].position.y = wallRight[1].position.y + wallRight[1].size.height
        }
        
        if (cameraNode.position.y > wallRight[1].position.y + wallRight[1].size.height) {
            wallRight[1].position.y = wallRight[0].position.y + wallRight[0].size.height
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
