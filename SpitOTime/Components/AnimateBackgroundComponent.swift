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
