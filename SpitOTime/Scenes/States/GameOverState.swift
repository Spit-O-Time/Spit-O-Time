//
//  GameOverState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit

class GameOverState: GKState {
    
    var gameStateCoordinator: GameStateCoordinator?
    var restart = true
    
    override func didEnter(from previousState: GKState?) {
        loadCoordinator()
        gameStateCoordinator?.route(to: .gameOver)
    }
    
    func loadCoordinator() {
        guard let gameStateMachine = stateMachine as? GameStateMachine else {
            return
        }
        
        gameStateCoordinator = GameStateCoordinator(stateMachine: gameStateMachine)
    }
    
}
