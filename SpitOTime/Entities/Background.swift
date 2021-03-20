//
//  Background.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 11/03/21.
//

import SpriteKit
import GameplayKit

class Background: GKEntity {
    
    override init() {
        super.init()
        self.addComponent(AnimateBackgroundComponent(shooterAsset: "llama",
                                                     backgroundAsset: "ground",
                                                     leftBarrierAsset: "wallLeft",
                                                     rightBarrierAsset: "wallRight"))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
