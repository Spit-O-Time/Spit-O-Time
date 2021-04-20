//
//  PausedStateTest.swift
//  SpitOTimeTests
//
//  Created by Paulo Uchôa on 08/04/21.
//

import XCTest
@testable import SpitOTime


class GameCoordinatorTests: XCTestCase {

    func teste_addScene_sceneNotNil() {
        // given
        let gameViewController = GameViewController()
        let sut = GameStateCoordinator(
            stateMachine: GameStateMachine(present: gameViewController, states: [])
        )
        let result = sut.addScene(controller: gameViewController).skView.scene
        XCTAssertNotNil(result)
    }
}
