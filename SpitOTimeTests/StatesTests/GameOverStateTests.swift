//
//  GameOverStateTest.swift
//  SpitOTimeTests
//
//  Created by Paulo Uchôa on 08/04/21.
//

import XCTest
@testable import SpitOTime

class GameOverStateTests: XCTestCase {

    func teste_loadCoordinator_true() {
        let gameStateMachine = GameStateMachine(present: GameOverViewController(), states: [GameOverState()])
        gameStateMachine.enter(GameOverState.self)
        
        let gameOverState = gameStateMachine.currentState as! GameOverState
       
        XCTAssertTrue(gameOverState.loadCoordinator())
    }
    
    func teste_loadCoordinator_false() {
        let sut = GameOverState()
        
        XCTAssertFalse(sut.loadCoordinator())
    }

}
