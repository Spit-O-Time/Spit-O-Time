//
//  PauseGameViewController.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 22/03/21.
//

import UIKit
import GameplayKit

class PauseGameViewController: UIViewController {

    weak var stateMachine: GKStateMachine?
    
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
    
    lazy var pauseLabel: UILabel = {
        let label = UILabel()
        label.text = "Pause"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .orange(size: 50)
        label.textColor = .titleLabel
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var resumeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.setTitle("Resume", for: .normal)
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
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupViewHierarchy() {
        view.addSubview(blur)
        view.addSubview(backgroundView)
        view.addSubview(pauseLabel)
        view.addSubview(resumeButton)
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
                let gameViewController = stateMachine.present as? GameViewController
                gameViewController?.skView.scene?.removeAllActions()
                gameViewController?.skView.scene?.removeAllChildren()
                gameViewController?.skView.scene?.removeFromParent()
                
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
            
            pauseLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            pauseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            pauseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            pauseLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 42),
            
            resumeButton.topAnchor.constraint(equalTo: pauseLabel.bottomAnchor, constant: 42),
            resumeButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            resumeButton.heightAnchor.constraint(equalToConstant: 64),
            resumeButton.widthAnchor.constraint(equalToConstant: 200),
            
            mainMenuButton.topAnchor.constraint(equalTo: resumeButton.bottomAnchor, constant: 24),
            mainMenuButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            mainMenuButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -32),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 64),
            mainMenuButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

}
