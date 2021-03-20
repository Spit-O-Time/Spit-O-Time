//
//  AnimatedSpriteComponent.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 11/03/21.
//  All rights reserved DO NOT COPY THIS FILE

import Foundation
import GameplayKit
import SpriteKit

private enum BarrierSide {
    case left
    case right
}

class AnimateBackgroundComponent: GKComponent {
    
    var grounds = [SKSpriteNode]()
    var wallLeft = [SKSpriteNode]()
    var wallRight = [SKSpriteNode]()
    var shooterCharacter = SKSpriteNode()

    init(shooterAsset: String,
         backgroundAsset: String,
         leftBarrierAsset: String,
         rightBarrierAsset: String) {
        super.init()
        grounds = createBackground(with: backgroundAsset)
        wallLeft = createBarrier(with: leftBarrierAsset, on: .left)
        wallRight = createBarrier(with: rightBarrierAsset, on: .right)
        shooterCharacter = createShooterCharacter(with: shooterAsset)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func createBackground(with asset: String) -> [SKSpriteNode] {
        let firstBackground = SKSpriteNode(imageNamed: asset)
        firstBackground.position = CGPoint(x: ScreenSize.width/2, y: 0)
        firstBackground.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        firstBackground.zPosition = -1
        let secondBackground = SKSpriteNode(imageNamed: asset)
        secondBackground.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        secondBackground.position = CGPoint(x: ScreenSize.width/2, y: firstBackground.frame.height)
        secondBackground.zPosition = -1
        return [firstBackground, secondBackground]
    }
    
    private func createBarrier(with asset: String, on side: BarrierSide) -> [SKSpriteNode] {
        let wall1 = SKSpriteNode(imageNamed: asset)
        
        var wall1Width: CGFloat
        switch side {
        case .left:
            wall1Width = wall1.size.width/2
        case .right:
            wall1Width = ScreenSize.width-wall1.size.width/2
        }
        
        wall1.position = CGPoint(x: wall1Width, y: 0)
        wall1.physicsBody = SKPhysicsBody(rectangleOf: wall1.size)
        wall1.physicsBody?.affectedByGravity = false
        wall1.physicsBody?.allowsRotation = false
        wall1.physicsBody?.isDynamic = false
        let wall2 = SKSpriteNode(imageNamed: asset)
        wall2.position = CGPoint(x: wall1Width, y: wall1.frame.height)
        wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2.size)
        wall2.physicsBody?.affectedByGravity = false
        wall2.physicsBody?.isDynamic = false
        
        return [wall1, wall2]
    }
    
    private func createShooterCharacter(with asset: String) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: asset)
        sprite.zPosition = 2
        sprite.position = CGPoint(x: ScreenSize.width/2, y: sprite.frame.height/2)
        return sprite
    }
    
    func updateBackground(cameraNode: SKCameraNode) {
        let spriteArrays = [grounds, wallRight, wallLeft]
        spriteArrays.forEach { (spriteArray) in
            
            if (cameraNode.position.y > spriteArray[0].position.y + spriteArray[0].size.height) {
                spriteArray[0].position.y = spriteArray[1].position.y + spriteArray[1].size.height
            }
            
            if (cameraNode.position.y > spriteArray[1].position.y + spriteArray[1].size.height) {
                spriteArray[1].position.y = spriteArray[0].position.y + spriteArray[0].size.height
            }
            
            shooterCharacter.position.y -= 2
            spriteArray[0].position.y -= 6
            spriteArray[1].position.y -= 6
        }
    }
    
}
