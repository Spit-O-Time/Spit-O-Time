//
//  DifficultHandler.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita Coelho on 07/09/24.
//

import Foundation

struct DifficultHandler {
    
    enum Difficult {
        case easy
        case medium
        case hard
    }
    
    static func secondsOfPlayingToDifficult(secondsOfPlaying: Float) -> Difficult {
        if secondsOfPlaying < 5 {
            return .easy
        }
        if secondsOfPlaying < 1000 {
            return .medium
        }
        if secondsOfPlaying < 5000 {
            return .hard
        }
        return .easy
    }
}
