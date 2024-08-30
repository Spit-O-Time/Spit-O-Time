//
//  MainMenuViewController.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 22/03/21.
//

import UIKit

class MainMenuViewController: UIViewController {

    var imageIconSoundEffectMuted: UIImage {
        let imageNamed = UserDefaultsManager.isSoundEffectMuted ? Assets.Icon.soundEffectDeactive : Assets.Icon.soundEffectActive
        return UIImage(named: imageNamed) ?? UIImage()
    }

    var imageIconBackgroundSoundMuted: UIImage {
        let imageNamed = UserDefaultsManager.isBackgroundSoundMuted ? Assets.Icon.backgroundSoundDeactive : Assets.Icon.backgroundSoundActive
        return UIImage(named: imageNamed) ?? UIImage()
    }
    
    var imageBackgound: UIImage {
        return UIImage(named: "bigLlama") ?? UIImage()
    }

    lazy var soundButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 8
        button.setImage(imageIconSoundEffectMuted, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changeSoundEffectAction), for: .touchUpInside)
        return button
    }()

    lazy var musicButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 8
        button.setImage(imageIconBackgroundSoundMuted, for: .normal)
        button.addTarget(self, action: #selector(changeBackgroundAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let audioManager = AudioManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaultsManager.isBackgroundSoundMuted == false {
            self.audioManager.playSound(named: .menuBackground, loop: true)
        }
        
        setupViewHierarchy()
        setupConstraints()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.audioManager.stopSound()
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
            self.audioManager.stopSound()
        } else {
            self.audioManager.playSound(named: .menuBackground, loop: true)
        }
    }

     @objc func changeSoundEffectAction(_ sender: UIButton) {
        UserDefaultsManager.toggleSoundEffectSound()
        soundButton.setImage(imageIconSoundEffectMuted, for: .normal)
    }
}


// MARK: - View
extension MainMenuViewController {
    
    private func setupViewHierarchy() {
        view.addSubview(soundButton)
        view.addSubview(musicButton)
        view.addSubview(playButton)
    }
    
    private func setupConstraints() {
        setupSoundEffectButton()
        setupBackgroundSoundButton()
        setupPlayButton()
        setupBackgroundView()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .blue
    }
    
    private func setupSoundEffectButton() {
        NSLayoutConstraint.activate([
            soundButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            soundButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32)
        ])
    }
    
    private func setupBackgroundSoundButton() {
        NSLayoutConstraint.activate([
            musicButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            musicButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func setupPlayButton() {
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
        
}
