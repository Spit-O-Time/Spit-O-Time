//
//  Llama.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 16/03/21.
//

import GameplayKit

class Llama: GKEntity {
    let sprites: [String] = [
        "llama0",
        "llama1",
        "llama2",
        "llama3"
    ]

    override init() {
        super.init()
        let llamaSize = CGSize(width: 83.8, height: 100)
        let llamaPhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 83.8, height: 50))

        self.addComponent(SpawnComponent(
            sprites: sprites,
            size: llamaSize
            , physicsBody: llamaPhysicsBody,
            categoryBitMask: .llama,
            contactTestBitMask: .spit
        ))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
