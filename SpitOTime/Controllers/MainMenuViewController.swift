//
//  MainMenuViewController.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 22/03/21.
//

import UIKit
import GameKit

class MainMenuViewController: UIViewController {

    var imageIconSoundEffectMuted: UIImage {
        let imageNamed = UserDefaultsManager.isSoundEffectMuted ? Assets.Icon.soundEffectDeactive : Assets.Icon.soundEffectActive
        return UIImage(named: imageNamed) ?? UIImage()
    }

    var imageIconBackgroundSoundMuted: UIImage {
        let imageNamed = UserDefaultsManager.isBackgroundSoundMuted ? Assets.Icon.backgroundSoundDeactive : Assets.Icon.backgroundSoundActive
        return UIImage(named: imageNamed) ?? UIImage()
    }
    
    lazy var imageBackgound: UIImageView = {
        let image = UIImage(named: "bigLlama")
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var gameTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .orange(size: 48)
        label.text = "spit\n 'o time"
        label.textColor = .titleLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    lazy var soundButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 8
        button.backgroundColor = .buttonColor
        button.setImage(imageIconSoundEffectMuted, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeThatFits(CGSize(width: 48, height: 48))
        button.addTarget(self, action: #selector(changeSoundEffectAction), for: .touchUpInside)
        return button
    }()

    lazy var musicButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 8
        button.setImage(imageIconBackgroundSoundMuted, for: .normal)
        button.addTarget(self, action: #selector(changeBackgroundAction), for: .touchUpInside)
        button.backgroundColor = .buttonColor
        button.sizeThatFits(CGSize(width: 48, height: 48))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var leaderBoardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 8
        button.setTitle("Leaderboard", for: .normal)
        button.titleLabel?.font = .nunito(size: 48)
        button.setTitleColor(.cardBackgroundColor, for: .normal)
        button.addTarget(self, action: #selector(didTapLeaderboardButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 8
        button.setTitle("PLAY", for: .normal)
        button.titleLabel?.font = .nunito(size: 48)
        button.setTitleColor(.cardBackgroundColor, for: .normal)
        button.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        setupConstraints()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaultsManager.isBackgroundSoundMuted == false {
            AudioManager.shared.playSound(named: .menuBackground, loop: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioManager.shared.stop()
    }
    
    func authenticateLocalPlayer() {
      let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            if let controller = viewController {
                self.navigationController?.present(controller, animated: true)
            }
        }
    }

    @objc func playButtonAction(_ sender: UIButton) {
        let controller = GameViewController()
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        transition.subtype = .none
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(controller, animated: false)
    }

    @objc func changeBackgroundAction(_ sender: UIButton) {
        UserDefaultsManager.toggleMuteBackgroundSound()
        musicButton.setImage(imageIconBackgroundSoundMuted, for: .normal)

        if UserDefaultsManager.isBackgroundSoundMuted {
            AudioManager.shared.stop()
        } else {
            AudioManager.shared.playSound(named: .menuBackground, loop: true)
        }
    }

     @objc func changeSoundEffectAction(_ sender: UIButton) {
        UserDefaultsManager.toggleSoundEffectSound()
        soundButton.setImage(imageIconSoundEffectMuted, for: .normal)
    }

    @objc func didTapLeaderboardButton(_ sender: UIButton) {
        let controller = GKGameCenterViewController(
            leaderboardID: "Leaderboard",
            playerScope: .global,
            timeScope: .allTime
        )
        controller.gameCenterDelegate = self
        self.navigationController?.present(controller, animated: true)
    }
}


// MARK: - View
extension MainMenuViewController {
    
    private func setupViewHierarchy() {
        view.addSubview(imageBackgound)
        view.addSubview(gameTitleLabel)
        view.addSubview(soundButton)
        view.addSubview(musicButton)
        view.addSubview(leaderBoardButton)
        view.addSubview(playButton)
    }
    
    private func setupConstraints() {
        setupImageBackground()
        setupGameTitleLabel()
        setupSoundEffectButton()
        setupBackgroundSoundButton()
        setupPlayButton()
        setupBackgroundView()
        setupLeaderboardButton()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .backgroundColor
    }
    
    private func setupSoundEffectButton() {
        NSLayoutConstraint.activate([
            soundButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            soundButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            soundButton.heightAnchor.constraint(equalToConstant: 42),
            soundButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setupBackgroundSoundButton() {
        NSLayoutConstraint.activate([
            musicButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            musicButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            musicButton.heightAnchor.constraint(equalToConstant: 42),
            musicButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func setupPlayButton() {
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func setupLeaderboardButton() {
        NSLayoutConstraint.activate([
            leaderBoardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            leaderBoardButton.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -24),
            leaderBoardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            leaderBoardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func setupGameTitleLabel() {
        NSLayoutConstraint.activate([
            gameTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            gameTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupImageBackground() {
        NSLayoutConstraint.activate([
            imageBackgound.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (UIScreen.main.bounds.width + 64) * -1),
            imageBackgound.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 4)
        ])
    }
        
}

extension MainMenuViewController: GKGameCenterControllerDelegate {

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        self.dismiss(animated: true)
    }

}
