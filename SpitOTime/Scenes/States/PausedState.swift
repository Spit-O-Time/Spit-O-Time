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
        loadCoordinator()
        gameStateCoordinator?.route(to: .paused)
    }
    
    func loadCoordinator() {
        guard let gameStateMachine = stateMachine as? GameStateMachine else {
            return
        }
        
        gameStateCoordinator = GameStateCoordinator(stateMachine: gameStateMachine)
    }
}
