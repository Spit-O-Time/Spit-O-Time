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
        if previousState is GameOverState {
            gameStateCoordinator?.route(to: .restart)
        } else if previousState is PausedState {
            gameStateCoordinator?.route(to: .resume)
        }
    }
    
    func loadCoordinator() {
        guard let gameStateMachine = stateMachine as? GameStateMachine else {
            return
        }
        
        gameStateCoordinator = GameStateCoordinator(stateMachine: gameStateMachine)
    }
    
}
