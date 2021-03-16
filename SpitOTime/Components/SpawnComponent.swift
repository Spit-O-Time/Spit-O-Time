//
//  SpawnComponent.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 16/03/21.
//

import GameplayKit
import SpriteKit

class SpawnComponent: GKComponent {
    
    var sprites: [SKSpriteNode]
    
    init(sprites: [String]) {
        self.sprites = sprites.compactMap {
            SKSpriteNode(imageNamed: $0)
        }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawn() -> SKSpriteNode? {
        
        let random = sprites.randomElement()
        let wall1 = SKSpriteNode(imageNamed: "wallLeft")
        let wall1Width = wall1.size.width/2
        let spawnAreaRight = ScreenSize.width - wall1Width
        let spawnAreaLeft = wall1Width
        let position = CGPoint(x: CGFloat.random(in: spawnAreaLeft...spawnAreaRight), y: ScreenSize.height + CGFloat.random(in: 0...ScreenSize.height))
        random?.position = position
        random?.zPosition = 0
        random?.physicsBody = SKPhysicsBody(rectangleOf: random!.size)
        random?.physicsBody?.affectedByGravity = false
        random?.physicsBody?.isDynamic = false
        random?.physicsBody?.allowsRotation = false
        random?.size = CGSize(width: 83.8, height: 100)
        return random
    }

    
}
