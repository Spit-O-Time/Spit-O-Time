//
//  PlayingState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit

protocol PlayingDelegate: AnyObject {
    func didRestartGame()
    func didResumeGame()
}

class PlayingState: GKState {

    weak var delegate: PlayingDelegate?

    init( delegate: PlayingDelegate) {
        self.delegate = delegate
    }

    override func didEnter(from previousState: GKState?) {
        if let gameOverState = previousState as? GameOverState {
            if !gameOverState.survive {
                delegate?.didRestartGame()
            }
        }
        if previousState is PausedState {
            delegate?.didResumeGame()
        }
    }
}
