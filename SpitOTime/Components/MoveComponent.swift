//
//  MoveComponent.swift
//  SpitOTime
//
//  Created by Paulo Uchôa on 09/03/21.
//

import Foundation
import CoreMotion
import GameplayKit

class MoveComponent: GKComponent {
    
    let motionManager = CMMotionManager()
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
}
