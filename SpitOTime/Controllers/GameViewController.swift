//
//  GameViewController.swift
//  SpitOTime
//
//  Created by Rodrigo Silva Ribeiro on 05/03/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let skView = SKView()
    var colorAmbience = UIView()
    
    lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 8
        button.backgroundColor = .buttonColor
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.tintColor = .cardBackgroundColor
        button.addTarget(self, action: #selector(pause), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func loadView() {
        super.loadView()
        self.view = skView
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene: GameScene = GameScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene.stateMachine = GameStateMachine(present: self, states: [GameOverState(), PausedState(), PlayingState()])

        scene.scaleMode = .aspectFill
        skView.showsPhysics = true
        skView.showsFPS = true
        skView.presentScene(scene)
        
        setupColorAmbience()
        setupPauseButton()
    }

    func setAmbienceColor(_ color: UIColor) {
        colorAmbience.backgroundColor = color
    }
    
    @objc func pause() {
        if let scene = skView.scene as? GameScene {
            skView.isPaused = true
            scene.stateMachine?.enter(PausedState.self)
        }
    }
    
    private func setupPauseButton() {
        self.view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pauseButton.heightAnchor.constraint(equalToConstant: 42),
            pauseButton.widthAnchor.constraint(equalTo: pauseButton.heightAnchor)
        ])
    }
    
    private func setupColorAmbience() {
        colorAmbience.backgroundColor = .black
        colorAmbience.alpha = 0.08
        colorAmbience.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(colorAmbience)
        NSLayoutConstraint.activate([
            colorAmbience.topAnchor.constraint(equalTo: view.topAnchor),
            colorAmbience.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            colorAmbience.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorAmbience.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

