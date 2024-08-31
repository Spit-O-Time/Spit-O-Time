//
//  GameOverState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit

protocol GameOverDelegate: AnyObject {
    func didLose()
}

class GameOverState: GKState {

    weak var scene: GameScene?
    weak var delegate: GameOverDelegate?

    init(scene: GameScene?, delegate: GameOverDelegate) {
        self.scene = scene
        self.delegate = delegate
    }

    override func didEnter(from previousState: GKState?) {
        if previousState is PlayingState {
            scene?.isPlaying = false
            delegate?.didLose()
        }
    }
}
