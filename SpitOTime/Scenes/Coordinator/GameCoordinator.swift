//
//  GameCoordinator.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import UIKit

protocol Coordinator {
    func start()
}

enum GameStateRoute {
    case paused
    case playing
    case gameOver
}

class GameStateCoordinator: Coordinator {
    
    var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        // Start coordinator
        print("error")
        
    }
    
    func route(to route: GameStateRoute) {
        switch  route {
        case .gameOver:
            print("gameOver")
            rootViewController?.present(GameViewController(), animated: true, completion: nil)
        case .paused:
            print("game paused")
        case .playing:
            print("is Playing")
        }
    }
    
}
