//
//  PlayingState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit

protocol PlayingDelegate: AnyObject {
    func didRestartGame()
}

class PlayingState: GKState {

    weak var scene: GameScene?
    weak var delegate: PlayingDelegate?

    init(scene: GameScene?, delegate: PlayingDelegate) {
        self.scene = scene
        self.delegate = delegate
    }

    override func didEnter(from previousState: GKState?) {
        if previousState is GameOverState {
            scene?.isPlaying = true
            delegate?.didRestartGame()
        }
        if previousState is PausedState {
            scene?.isPlaying = true
            scene?.worldNode.isPaused = false
        }
    }
}
