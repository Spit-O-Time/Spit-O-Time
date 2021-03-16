//
//  Obstacle.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 16/03/21.
//

import GameplayKit

class Obstacle: GKEntity {
    lazy var sprites: [String] = {
        var sprites = [String]()
        for i in 0...3 {
            sprites.append("llama\(i)")
        }
        return sprites
    }()
    
    override init() {
        super.init()
        self.addComponent(SpawnComponent(sprites: sprites))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
