//
//  GameOverState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameKit

protocol GameOverDelegate: AnyObject {
    func didLoseGame()
}

class GameOverState: GKState {

    weak var delegate: GameOverDelegate?
    public var survive: Bool = false

    init(delegate: GameOverDelegate) {
        self.delegate = delegate
    }

    override func didEnter(from previousState: GKState?) {
        if previousState is PlayingState {
            delegate?.didLoseGame()
        }
    }


    
}
