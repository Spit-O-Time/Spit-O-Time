//
//  Spit.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 11/03/21.
//

import GameplayKit
import SpriteKit

class Spit: GKEntity {

    override init() {
        super.init()
        self.addComponent(AnimateSpriteComponent(
            textureName: String(),
            categoryBitMask: .spit,
            collisionBitMask: CategoryMask.collides(bodyA: .llama, bodyB: .spit),
            size: CGSize(width: 25, height: 25))
        )
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
