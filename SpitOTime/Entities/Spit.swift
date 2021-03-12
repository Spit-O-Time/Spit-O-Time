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
        self.addComponent(AnimatedSpriteComponent())
        self.addComponent(MoveComponent())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
