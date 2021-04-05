//
//  GameViewController.swift
//  SpitOTime
//
//  Created by Rodrigo Silva Ribeiro on 05/03/21.
//

import UIKit
import SpriteKit
import GameplayKit
import Lottie

class GameViewController: UIViewController {

    let skView = SKView()
    var colorAmbience = UIView()
    var scene: GameScene?
    var animationView: AnimationView!
    
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
        
        scene = GameScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        scene?.stateMachine = GameStateMachine(present: self, states: [GameOverState(), PausedState(), PlayingState()])
        
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        scene?.scaleMode = .aspectFill
        skView.presentScene(scene!)
        setupColorAmbience()
        setupPauseButton()
        countAnimationIfNeeded()
        tutorialAnimationIfNeeded()
        animateColorAmbience()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.layer.removeAllAnimations()
    }
    
    @objc func appMovedToBackground() {
        if let scene = skView.scene as? GameScene {
            skView.isPaused = true
            scene.isPlaying = false
            scene.stateMachine?.enter(PausedState.self)
        }
    }

    func setAmbienceColor(_ color: UIColor, with alpha: CGFloat = 0.1) {
        colorAmbience.backgroundColor = color
        colorAmbience.alpha = alpha
    }
    
    private func animateColorAmbience() {
        setAmbienceColor(.orange, with: 0.04)
        UIView.animate(withDuration: 40, delay: 0, options: [.repeat, .autoreverse]) {
            self.setAmbienceColor(.black, with: 0.4)
        }
    }
    
    @objc func pause() {
        if let scene = skView.scene as? GameScene {
            skView.isPaused = true
            scene.isPlaying = false
            scene.stateMachine?.enter(PausedState.self)
        }
    }
    
    func countAnimationIfNeeded() {
        guard UserDefaults.standard.bool(forKey: UserDefaultsKey.notFirstTime.rawValue) else { return }
        animationView = .init(name: "count")
        animationView.contentMode = .scaleAspectFit
        setupAnimationView(withSize: CGSize(width: 200, height: 200))
        animationView.play { _ in
            self.scene?.isRunningAnimationCount = true
            UIView.animate(withDuration: 0.3) {
                self.animationView.alpha = 0
            } completion: { _ in
                self.animationView.isHidden = true
                self.scene?.isRunningAnimationCount = false
            }
        }
    }
    
    private func tutorialAnimationIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: UserDefaultsKey.notFirstTime.rawValue) else { return }
        animationView = .init(name: "tutorial_movement")
        animationView.animationSpeed = 0.5
        animationView.contentMode = .scaleToFill
        setupAnimationView(withSize: CGSize(width: 500, height: 500))
        animationView.play { _ in
            UIView.animate(withDuration: 0.3) {
                self.animationView.alpha = 0
            } completion: { _ in
                self.animationView.isHidden = true
            }
        }
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.notFirstTime.rawValue)
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
        colorAmbience.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(colorAmbience)
        NSLayoutConstraint.activate([
            colorAmbience.topAnchor.constraint(equalTo: view.topAnchor),
            colorAmbience.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            colorAmbience.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorAmbience.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupAnimationView(withSize size: CGSize) {
        self.view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.heightAnchor.constraint(equalToConstant: size.height),
            animationView.widthAnchor.constraint(equalToConstant: size.width)
        ])
    }
}

