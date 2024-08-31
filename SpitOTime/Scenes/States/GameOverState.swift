//
//  GameOverState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit
import GameKit

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
            reportToLeaderboard(score: scene?.score ?? .zero)
            delegate?.didLose()
        }
    }

    func reportToLeaderboard(score: Int) {
        GKLeaderboard.submitScore(score, context: .zero, player: GKLocalPlayer.local, leaderboardIDs: ["Leaderboard"]) { err in
            print(err?.localizedDescription)
        }
    }
    
}
