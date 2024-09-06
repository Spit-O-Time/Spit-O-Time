//
//  GameOverViewController.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 18/03/21.
//

import UIKit
import GameplayKit
import GoogleMobileAds

class GameOverViewController: UIViewController {

    var rewardedAd: GADRewardedAd?
    var canRequestAd: Bool = true
    weak var stateMachine: GKStateMachine?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupViewHierarchy() {
        view.addSubview(blur)
        view.addSubview(backgroundView)
        view.addSubview(gameOverLabel)
        if canRequestAd {
            view.addSubview(continueButton)
        }
        view.addSubview(restartButton)
        view.addSubview(mainMenuButton)
        view.addSubview(activityIndicator)
    }
    
    @objc func resume() {
        if canRequestAd {
            Task {
                await loadRewardedAd()
                openRewardedAd()
            }
        }
    }
    
    @objc func restart() {
        stateMachine?.enter(PlayingState.self)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goToMainMenu() {
        guard let rootViewController = view.window?.rootViewController as? UINavigationController else {
            return
        }
        rootViewController.modalTransitionStyle = .crossDissolve
        rootViewController.dismiss(animated: true)
        rootViewController.popToRootViewController(animated: false)
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
        
        if canRequestAd {
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

extension GameOverViewController: GADFullScreenContentDelegate {

    private func loadRewardedAd() async {
        do {
            rewardedAd = try await GADRewardedAd.load(
                withAdUnitID: "ca-app-pub-7538778908277058/7924882279",
                request: GADRequest()
            )
            rewardedAd?.fullScreenContentDelegate = self
        } catch {
            presentAlert(
                title: "Falha ao carregar, não é possivel continuar",
                message: "Alguma llama mordeu o cabo de conexão com os nossos servidores"
            )
        }
    }

    private func openRewardedAd() {
        guard let ad = rewardedAd else {
            return
        }
        ad.present(fromRootViewController: self) {
            let reward = ad.adReward
        }
    }

    func ad(
       _ ad: GADFullScreenPresentingAd,
       didFailToPresentFullScreenContentWithError error: Error
     ) {
       print("Rewarded ad failed to present with error: \(error.localizedDescription).")
     }

    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(
          title: title,
          message: message,
          preferredStyle: .alert)
        let alertAction = UIAlertAction(
          title: "Ok!",
          style: .cancel)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}
