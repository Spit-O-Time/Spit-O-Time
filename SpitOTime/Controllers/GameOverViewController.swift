//
//  GameOverViewController.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 18/03/21.
//
//  AdMob App Id: ca-app-pub-9249585883419480~8364095003
//  AdMob Block Id: ca-app-pub-9249585883419480/2345481567
//  AdMob Test Id: ca-app-pub-3940256099942544/1712485313

import UIKit
import GameplayKit
import GoogleMobileAds

class GameOverViewController: UIViewController {

    var rewardedAd: GADRewardedAd?
    
    weak var stateMachine: GKStateMachine?
    
    lazy var audioManager = AudioManager()
    
    lazy var blur: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.alpha = 0.6
        blurView.frame = self.view.bounds
        return blurView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.setTitle("Keep Going", for: .normal)
        button.titleLabel?.font = .nunito(size:20)
        button.setTitleColor(.cardBackgroundColor, for: .normal)
        button.addTarget(self, action: #selector(resume), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var restartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.setTitle("Restart", for: .normal)
        button.titleLabel?.font = .nunito(size:20)
        button.setTitleColor(.cardBackgroundColor, for: .normal)
        button.addTarget(self, action: #selector(restart), for: .touchUpInside)
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
    
    var surviveState: Bool {
        get {
            guard let stateMachine = stateMachine as? GameStateMachine,
            let gameViewController = stateMachine.present as? GameViewController,
            let scene = gameViewController.skView.scene as? GameScene else { return false }
            return scene.didSurvive
        }
        set {
            if let stateMachine = stateMachine as? GameStateMachine,
            let gameViewController = stateMachine.present as? GameViewController,
            let scene = gameViewController.skView.scene as? GameScene {
                scene.didSurvive = newValue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? audioManager.playSound(named: .gameOver, volume: 3.0)
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func loadRewardedAd() {
        let request = GADRequest()
        
        self.rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-9249585883419480/2345481567")
//        #if DEBUG
//            self.rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
//        #endif

        self.rewardedAd?.load(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
                self.activityIndicator.stopAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.openRewardedAd()
            }
        }
    }
    
    private func openRewardedAd() {
        self.rewardedAd?.present(fromRootViewController: self,
                                 delegate: self)
    }
    
    private func setupViewHierarchy() {
        view.addSubview(blur)
        view.addSubview(backgroundView)
        view.addSubview(gameOverLabel)
        if !surviveState {
            view.addSubview(continueButton)
        }
        view.addSubview(restartButton)
        view.addSubview(mainMenuButton)
        view.addSubview(activityIndicator)
    }
    
    @objc func resume() {
        activityIndicator.startAnimating()
        loadRewardedAd()
    }
    
    @objc func restart() {
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
            
        ])
        
        if !surviveState {
            NSLayoutConstraint.activate([
                continueButton.topAnchor.constraint(equalTo: gameOverLabel.bottomAnchor, constant: 42),
                continueButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                continueButton.heightAnchor.constraint(equalToConstant: 64),
                continueButton.widthAnchor.constraint(equalToConstant: 200),
                restartButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 24),
            ])
        } else {
            restartButton.topAnchor.constraint(equalTo: gameOverLabel.bottomAnchor, constant: 24).isActive = true
        }
        
        NSLayoutConstraint.activate([
            restartButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            restartButton.heightAnchor.constraint(equalToConstant: 64),
            restartButton.widthAnchor.constraint(equalToConstant: 200),
            
            mainMenuButton.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: 24),
            mainMenuButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            mainMenuButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -32),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 64),
            mainMenuButton.widthAnchor.constraint(equalToConstant: 200),
            
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.leftAnchor.constraint(equalTo: view.leftAnchor),
            activityIndicator.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

}

extension GameOverViewController: GADRewardedAdDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        if let stateMachine = self.stateMachine?.currentState as? GameOverState {
            stateMachine.restart = false
            self.surviveState = true
        }
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        if let stateMachine = self.stateMachine?.currentState as? GameOverState {
            if !stateMachine.restart {
                self.dismiss(animated: true) {
                    self.stateMachine?.enter(PlayingState.self)
                    stateMachine.restart = true
                }
            }
        }
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        activityIndicator.stopAnimating()
    }
}
