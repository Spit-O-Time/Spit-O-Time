//
//  GameStateMachine.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit
import SpriteKit

class GameStateMachine: GKStateMachine {
    
    weak var present: UIViewController?
    
    init(present: UIViewController, states: [GKState]) {
        self.present = present
        super.init(states: states)
    }
}
