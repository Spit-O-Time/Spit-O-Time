//
//  PlayingState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit

class PlayingState: GKState {
    
    var gameStateCoordinator: GameStateCoordinator?
    
    override func didEnter(from previousState: GKState?) {
        loadCoordinator()
        if let previousState = previousState as? GameOverState {
            if previousState.restart {
                gameStateCoordinator?.route(to: .restart)
            } else {
                gameStateCoordinator?.route(to: .resume)
            }
        } else if previousState is PausedState {
            gameStateCoordinator?.route(to: .resume)
        }
    }
    
    func loadCoordinator() -> Bool {
        guard let gameStateMachine = stateMachine as? GameStateMachine else {
            return false
        }
        
        gameStateCoordinator = GameStateCoordinator(stateMachine: gameStateMachine)
        
        return true
    }
    
}
