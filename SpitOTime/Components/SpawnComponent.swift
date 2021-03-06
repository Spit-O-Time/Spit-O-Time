//
//  SpawnComponent.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 16/03/21.
//

import GameplayKit
import SpriteKit

class SpawnComponent: GKComponent {
    
    var sprites: [String]!
    
    init(sprites: [String]) {
        self.sprites = sprites
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawn() -> SKSpriteNode {
        let random = SKSpriteNode(imageNamed: sprites.randomElement() ?? "")
        random.zPosition = 0
        random.size = CGSize(width: 83.8, height: 100)
        random.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: random.size.width, height: random.size.height/2))
        random.physicsBody?.affectedByGravity = false
        random.physicsBody?.isDynamic = false
        random.physicsBody?.allowsRotation = false
        
        let wall1 = SKSpriteNode(imageNamed: "wallLeft")
        let wall1Width = wall1.size.width/2
        let spawnAreaRight = ScreenSize.width - wall1Width - random.frame.width/2
        let spawnAreaLeft = wall1Width + random.frame.width/2
        let position = CGPoint(x: CGFloat.random(in: spawnAreaLeft...spawnAreaRight),
                               y: ScreenSize.height + CGFloat.random(in: 0...ScreenSize.height))
        random.position = position
        random.physicsBody?.categoryBitMask = CategoryMask.obstacle.rawValue
        random.physicsBody?.contactTestBitMask = CategoryMask.spit.rawValue
        return random
    }

    
}
