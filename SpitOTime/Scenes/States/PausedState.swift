//
//  PausedState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit

class PausedState: GKState {

    weak var scene: GameScene?

    init(scene: GameScene?) {
        self.scene = scene
    }

    override func didEnter(from previousState: GKState?) {
        if previousState is PlayingState {
            scene?.isPlaying = false
            scene?.worldNode.isPaused = true
        }
    }
}
