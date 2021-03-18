//
//  GameCoordinator.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import UIKit
import GameplayKit

protocol Coordinator {
    func start()
}

enum GameStateRoute {
    case paused
    case playing
    case gameOver
}

class GameStateCoordinator: Coordinator {
    
    var stateMachine: GameStateMachine?
    
    init(stateMachine: GameStateMachine?) {
        self.stateMachine = stateMachine
    }
    
    func start() {
        // Start coordinator
        print("error")
        
    }
    
    func route(to route: GameStateRoute) {
        switch  route {
        case .gameOver:
            print("gameOver")
            let controller = GameOverViewController()
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
            controller.stateMachine = stateMachine
            stateMachine?.present?.present(controller, animated: true, completion: nil)
        case .paused:
            print("game paused")
        case .playing:
            print("is Playing")
        }
    }
    
}
