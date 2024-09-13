//
//  ScoreHandler.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita Coelho on 07/09/24.
//

import Foundation


struct ScoreHandler {

    let secondsOfPlaying: Int
    let multiplierMedium: Float = 1.5
    let multiplierHard: Float = 1.1

    func calculate() -> Int {
        let secounds = Float(secondsOfPlaying)
        let difficult = DifficultHandler
            .secondsOfPlayingToDifficult(
                secondsOfPlaying: secounds
            )
        switch difficult {
        case .easy:
            return Int(powf(2, secounds))
        case .medium:
            return Int(secounds * multiplierMedium)
        case .hard:
            return Int(secounds * multiplierHard)
        }
    }
}
