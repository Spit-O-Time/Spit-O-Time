//
//  GameOverViewController.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 18/03/21.
//

import UIKit
import GameplayKit

class GameOverViewController: UIViewController {

    weak var stateMachine: GKStateMachine?
    
    lazy var audioManager = AudioManager()
    
    lazy var blur: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.alpha = 0.6
        blurView.frame = self.view.bounds
        return blurView
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardBackgroundColor
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var gameOverLabel: UILabel = {
        let label = UILabel()
        label.text = "Game\nOver"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .orange(size: 50)
        label.textColor = .titleLabel
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var restartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.setTitle("Restart", for: .normal)
        button.titleLabel?.font = .nunito(size:20)
        button.setTitleColor(.cardBackgroundColor, for: .normal)
        button.addTarget(self, action: #selector(resume), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var mainMenuButton: UIButton = {
        let button = UIButton()
        button.setTitle("Main Menu", for: .normal)
        button.setTitleColor(.buttonColor, for: .normal)
        button.titleLabel?.font = .nunito(size:20)
        button.addTarget(self, action: #selector(goToMainMenu), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioManager.playSound(named: .gameOver, volume: 3.0)
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupViewHierarchy() {
        view.addSubview(blur)
        view.addSubview(backgroundView)
        view.addSubview(gameOverLabel)
        view.addSubview(restartButton)
        view.addSubview(mainMenuButton)
    }
    
    @objc func resume() {
        stateMachine?.enter(PlayingState.self)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goToMainMenu() {
        dismiss(animated: true) {
            if let stateMachine = self.stateMachine as? GameStateMachine {
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = .fade
                transition.subtype = .none
                stateMachine.present?.navigationController?.view.layer.add(transition, forKey: kCATransition)
                stateMachine.present?.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            gameOverLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            gameOverLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            gameOverLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            gameOverLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 42),
            
            restartButton.topAnchor.constraint(equalTo: gameOverLabel.bottomAnchor, constant: 42),
            restartButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            restartButton.heightAnchor.constraint(equalToConstant: 64),
            restartButton.widthAnchor.constraint(equalToConstant: 200),
            
            mainMenuButton.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: 24),
            mainMenuButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            mainMenuButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -32),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 64),
            mainMenuButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

}
