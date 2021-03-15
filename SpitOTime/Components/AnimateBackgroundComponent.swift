//
//  AnimatedSpriteComponent.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 11/03/21.
//  All rights reserved DO NOT COPY THIS FILE

import Foundation
import GameplayKit
import SpriteKit

class AnimateBackgroundComponent: GKComponent {
    
    var grounds: [SKSpriteNode] = {
        let firstBackground = SKSpriteNode(imageNamed: "ground")
        firstBackground.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2)
        firstBackground.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        firstBackground.zPosition = -1
        let secondBackground = SKSpriteNode(imageNamed: "ground")
        secondBackground.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        secondBackground.position = CGPoint(x: ScreenSize.width/2, y: firstBackground.frame.height)
        secondBackground.zPosition = -1
        return [firstBackground, secondBackground]
    }()
    var wallLeft: [SKSpriteNode] = {
        let wall1 = SKSpriteNode(imageNamed: "wallLeft")
        let wall1Width = wall1.size.width/2
        wall1.position = CGPoint(x: wall1Width, y: ScreenSize.height/2)
        wall1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wall1.size.width, height: ScreenSize.height))
        wall1.physicsBody?.affectedByGravity = false
        wall1.physicsBody?.allowsRotation = false
        
        let wall2 = SKSpriteNode(imageNamed: "wallLeft")
        wall2.position = CGPoint(x: wall1Width, y: wall1.frame.height)
        wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2.size)
        wall2.physicsBody?.affectedByGravity = false
        return [wall1, wall2]
    }()
    var wallRight: [SKSpriteNode] = {
        let wall1 = SKSpriteNode(imageNamed: "wallRight")
        let wall1Width = ScreenSize.width-wall1.size.width/2
        wall1.position = CGPoint(x: wall1Width, y: ScreenSize.height/2)
        wall1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wall1.size.width, height: ScreenSize.height))
        wall1.physicsBody?.affectedByGravity = false
        wall1.physicsBody?.allowsRotation = false
        
        let wall2 = SKSpriteNode(imageNamed: "wallRight")
        wall2.position = CGPoint(x: wall1Width, y: wall1.frame.height)
        wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2.size)
        wall2.physicsBody?.affectedByGravity = false
        return [wall1, wall2]
    }()

    func updateBackground(cameraNode: SKCameraNode) {
        let spriteArrays = [grounds, wallRight, wallLeft]
        spriteArrays.forEach { (spriteArray) in
            if (cameraNode.position.y > spriteArray[0].position.y + spriteArray[0].size.height) {
                spriteArray[0].position.y = spriteArray[1].position.y + spriteArray[1].size.height
            }
            
            if (cameraNode.position.y > spriteArray[1].position.y + spriteArray[1].size.height) {
                spriteArray[1].position.y = spriteArray[0].position.y + spriteArray[0].size.height
            }
        }
    }
    
}
