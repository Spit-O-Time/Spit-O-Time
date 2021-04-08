//
//  PausedStateTest.swift
//  SpitOTimeTests
//
//  Created by Paulo Uchôa on 08/04/21.
//

import XCTest
@testable import  SpitOTime


class PausedStateTest: XCTestCase {

    func teste_loadCoordinator_true() {
        let gameStateMachine = GameStateMachine(present: PauseGameViewController(), states: [PausedState()])
        gameStateMachine.enter(PausedState.self)
        
        let pausedState = gameStateMachine.currentState as! PausedState
       
        XCTAssertTrue(pausedState.loadCoordinator())
    }
    
    func teste_loadCoordinator_false() {
        let sut = PausedState()
        
        XCTAssertFalse(sut.loadCoordinator())
    }
    
}
