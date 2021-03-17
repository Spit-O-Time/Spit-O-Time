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
        self.addComponent(AnimateSpriteComponent(atlasName: "SpitAtlas"))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
