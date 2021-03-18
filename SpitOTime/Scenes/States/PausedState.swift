//
//  PausedState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit

class PausedState: GKState {
    
    var gameStateCoordinator: GameStateCoordinator?

    override func didEnter(from previousState: GKState?) {
        gameStateCoordinator?.route(to: .paused)
    }
    
}
