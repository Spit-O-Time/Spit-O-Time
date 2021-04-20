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
    
    @discardableResult
    func loadCoordinator() -> Bool {
        guard let gameStateMachine = stateMachine as? GameStateMachine else {
            return false
        }
        
        gameStateCoordinator = GameStateCoordinator(stateMachine: gameStateMachine)
        
        return true
    }
    
}
