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
import GameKit

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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
            selector: #selector(appMovedToBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )

        startScene()
        setupColorAmbience()
        setupPauseButton()
        countAnimationIfNeeded()
        tutorialAnimationIfNeeded()
        animateColorAmbience()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaultsManager.isBackgroundSoundMuted == false {
            AudioManager.shared.playSound(named: .background, loop: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.layer.removeAllAnimations()
    }

    func startScene() {
        let sceneSize = CGSize(
            width: ScreenSize.width,
            height: ScreenSize.height
        )
        scene = GameScene(size: sceneSize)
        scene?.scaleMode = .aspectFill
        let stateMachine = GKStateMachine(
            states: [
                GameOverState(delegate: self),
                PausedState(delegate: self),
                PlayingState(delegate: self)
            ]
        )
        scene?.stateMachine = stateMachine
        skView.presentScene(scene)
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
        UIView.animate(
            withDuration: 40,
            delay: 0,
            options: [.repeat, .autoreverse]
        ) {
            self.setAmbienceColor(.black, with: 0.4)
        }
    }
    
    @objc func pause() {
        scene?.stateMachine?.enter(PausedState.self)
        goToPauseViewController()
    }
    
    func countAnimationIfNeeded() {
        guard UserDefaultsManager.isFirstTimePlaying == false else { return }
        animationView = .init(name: "count")
        animationView.contentMode = .scaleAspectFit
        setupAnimationView(withSize: CGSize(width: 200, height: 200))
        animationView.play { _ in
            self.fadeOutAnimation()
        }
    }
    
    private func tutorialAnimationIfNeeded() {
        guard UserDefaultsManager.isFirstTimePlaying else { return }
        animationView = .init(name: "tutorial_movement")
        animationView.animationSpeed = 0.7
        animationView.contentMode = .scaleToFill
        setupAnimationView(withSize: CGSize(width: 500, height: 500))
        animationView.play { _ in
            self.fadeOutAnimation()
        }
    }
    
    private func fadeOutAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.animationView.alpha = 0
        } completion: { _ in
            self.animationView.isHidden = true
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


// MARK: Navigation
extension GameViewController {
    
    func goToPauseViewController() {
        let controller = PauseGameViewController()
        controller.stateMachine = scene?.stateMachine
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(controller, animated: true)
    }

    func goToGameOverViewController() {
        let controller = GameOverViewController()
        controller.stateMachine = scene?.stateMachine
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(controller, animated: true)
    }

}

// MARK: State Delegates
extension GameViewController: GameOverDelegate, PlayingDelegate, PauseDelegate {
    func didPauseGame() {
        scene?.isPlaying = false
        scene?.isPaused = true
        animationView.pause()
        AudioManager.shared.pause()
    }

    func didResumeGame() {
        scene?.isPaused = false
        scene?.isPlaying = true
        animationView.play()
        if UserDefaultsManager.isBackgroundSoundMuted == false {
            AudioManager.shared.resume()
        }
    }

    func didRestartGame() {
        startScene()
    }

    func didLoseGame() {
        scene?.isPlaying = false
        AudioManager.shared.stop()
        UserDefaultsManager.setUserPlayedFirstTime()
        goToGameOverViewController()
        AudioManager.shared.playSound(named: .gameOver, loop: false, volume: 10.0)
    }
    
}

// MARK: Leaderboard
extension GameViewController {
    func reportToLeaderboard(score: Int) {
        GKLeaderboard.submitScore(score, context: .zero, player: GKLocalPlayer.local, leaderboardIDs: ["Leaderboard"]) { err in
            print(err?.localizedDescription ?? String())
        }
    }
}
