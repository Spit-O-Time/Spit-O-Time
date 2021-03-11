//
//  Background.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 11/03/21.
//

import Foundation
import SpriteKit
import GameplayKit

class Background: GKEntity {
    let backgrounds: [SKSpriteNode] = {
        let initialBackground = SKSpriteNode()
        let firstBackground = SKSpriteNode()
        let secondBackground = SKSpriteNode()
        
        return [initialBackground, firstBackground, secondBackground]
    }()
    
    func animateBackground() {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        animateBackground()
    }
}
