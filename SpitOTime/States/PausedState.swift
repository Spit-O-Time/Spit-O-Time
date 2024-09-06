//
//  PausedState.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import GameplayKit

protocol PauseDelegate: AnyObject {
    func didPauseGame()
}

class PausedState: GKState {

    weak var delegate: PauseDelegate?

    init(delegate: PauseDelegate?) {
        self.delegate = delegate
    }

    override func didEnter(from previousState: GKState?) {
        delegate?.didPauseGame()
    }
}
