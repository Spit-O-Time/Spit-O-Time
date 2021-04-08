//
//  PlayingStateTests.swift
//  SpitOTimeTests
//
//  Created by Paulo Uchôa on 08/04/21.
//

import XCTest
@testable import SpitOTime

class PlayingStateTests: XCTestCase {

    func teste_loadCoordinator_true() {
        let gameStateMachine = GameStateMachine(present: GameViewController(), states: [PlayingState()])
        gameStateMachine.enter(PlayingState.self)
        
        let playingState = gameStateMachine.currentState as! PlayingState
       
        XCTAssertTrue(playingState.loadCoordinator())
    }
    
    func teste_loadCoordinator_false() {
        let sut = PlayingState()
        
        XCTAssertFalse(sut.loadCoordinator())
    }
    
    func teste_didEnter_GameOverState_true() {
        let gameStateMachine = GameStateMachine(present: GameViewController(), states: [PlayingState(), PausedState(), GameOverState()])
        gameStateMachine.enter(GameOverState.self)
        gameStateMachine.enter(PlayingState.self)
        
        let playingState = gameStateMachine.currentState as! PlayingState
       
        XCTAssertTrue(playingState.loadCoordinator())
    }
    
    func teste_didEnter_PausedState_true() {
        let gameStateMachine = GameStateMachine(present: GameViewController(), states: [PlayingState(), PausedState(), GameOverState()])
        gameStateMachine.enter(PausedState.self)
        gameStateMachine.enter(PlayingState.self)
        
        let playingState = gameStateMachine.currentState as! PlayingState
       
        XCTAssertTrue(playingState.loadCoordinator())
    }
    
    func teste_didEnter_RandomState_true() {
        let gameStateMachine = GameStateMachine(present: GameViewController(), states: [PlayingState(), GameOverState()])
        gameStateMachine.enter(GameOverState.self)
        let gameoOverState = gameStateMachine.currentState as! GameOverState
        gameoOverState.restart = false
        
        gameStateMachine.enter(PlayingState.self)
        
        let playingState = gameStateMachine.currentState as! PlayingState
       
        XCTAssertTrue(playingState.loadCoordinator())
    }
    
    

}
