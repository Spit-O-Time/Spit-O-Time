//
//  MainMenuViewController.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 22/03/21.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var sound: UIButton! {
        didSet {
            sound.layer.masksToBounds = false
            sound.layer.cornerRadius = 8
        }
    }

    @IBOutlet weak var music: UIButton! {
        didSet {
            music.layer.masksToBounds = false
            music.layer.cornerRadius = 8
        }
    }

    @IBOutlet weak var play: UIButton! {
        didSet {
            play.layer.masksToBounds = false
            play.layer.cornerRadius = 16
        }
    }

    let audioManager = AudioManager()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            try? self.audioManager.playSound(named: .menuBackground, numberOfLoop: -1, volume: 0.5)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonImage(forKey: .isSoundEffectMuted, button: sound)
        setButtonImage(forKey: .isSoundtrackMuted, button: music)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.audioManager.stopSound()
    }

    @IBAction func playButtonAction(_ sender: Any) {
        let controller = GameViewController()
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        transition.subtype = .none
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(controller, animated: false)
    }

    @IBAction func changeSoundtrackAction(_ sender: Any) {
        changeValueUserDefaults(forKey: .isSoundtrackMuted, button: music)
    }

    @IBAction func changeSoundEffectAction(_ sender: Any) {
        changeValueUserDefaults(forKey: .isSoundEffectMuted, button: sound)
    }

    func changeValueUserDefaults(forKey key: AudioConfig, button: UIButton) {
        switch key {
        case .isSoundtrackMuted:
            if UserDefaults.standard.bool(forKey: key.rawValue) {
                UserDefaults.standard.setValue(false, forKey: key.rawValue)
                button.setImage(UIImage(named: key.rawValue+"_deactive"), for: .normal)
                self.audioManager.stopSound()
            } else {
                UserDefaults.standard.setValue(true, forKey: key.rawValue)
                button.setImage(UIImage(named: key.rawValue+"_active"), for: .normal)
                self.audioManager.playSound(named: .menuBackground, numberOfLoop: -1, volume: 0.5)
            }
            
        case .isSoundEffectMuted:
            if UserDefaults.standard.bool(forKey: key.rawValue) {
                UserDefaults.standard.setValue(false, forKey: key.rawValue)
                button.setImage(UIImage(named: key.rawValue+"_deactive"), for: .normal)
            } else {
                UserDefaults.standard.setValue(true, forKey: key.rawValue)
                button.setImage(UIImage(named: key.rawValue+"_active"), for: .normal)
            }
        }
        UserDefaults.standard.synchronize()
        print(UserDefaults.standard.bool(forKey: key.rawValue))
    }

    func setButtonImage(forKey: AudioConfig, button: UIButton) {
        if !UserDefaults.standard.bool(forKey: forKey.rawValue) {
            button.setImage(UIImage(named: forKey.rawValue+"_deactive"), for: .normal)
        } else {
            button.setImage(UIImage(named: forKey.rawValue+"_active"), for: .normal)
        }
        
    }
}
