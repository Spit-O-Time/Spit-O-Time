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
    case restart
    case resume
    case gameOver
}

class GameStateCoordinator: Coordinator {
    
    weak var stateMachine: GameStateMachine?
    
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
            let controller = PauseGameViewController()
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
            controller.stateMachine = stateMachine
            stateMachine?.present?.present(controller, animated: true, completion: nil)
        case .restart:
            let gameViewController = stateMachine?.present as? GameViewController
            gameViewController?.countAnimationIfNeeded()
            gameViewController?.skView.scene?.removeAllActions()
            gameViewController?.skView.scene?.removeAllChildren()
            gameViewController?.skView.scene?.removeFromParent()
            if let controller = gameViewController { addScene(controller: controller) }
        case .resume:
            let gameViewController = stateMachine?.present as? GameViewController
            if let scene = gameViewController?.skView.scene as? GameScene {
                scene.isPlaying = true
            }
            gameViewController?.skView.isPaused = false
        }
    }
    
    func addScene(controller: GameViewController) {
        let scene = GameScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.stateMachine = GameStateMachine(present: controller, states: [GameOverState(), PausedState(), PlayingState()])
        scene.scaleMode = .aspectFill
        controller.skView.showsPhysics = true
        controller.skView.showsFPS = true
        controller.skView.presentScene(scene)
    }
    
}
