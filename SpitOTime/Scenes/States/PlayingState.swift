//
//  PlayingState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit

class PlayingState: GKState {

    weak var scene: GameScene?

    init(scene: GameScene?) {
        self.scene = scene
    }

    override func didEnter(from previousState: GKState?) {
        if previousState is GameOverState {
            scene?.isPlaying = true
        }
        if previousState is PausedState {
            scene?.isPlaying = true
            scene?.worldNode.isPaused = false
        }
    }
}
