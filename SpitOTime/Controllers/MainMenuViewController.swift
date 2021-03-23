//
//  MainMenuViewController.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 22/03/21.
//

import UIKit
import GameKit
class MainMenuViewController: UIViewController, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
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
    
    @IBOutlet weak var leaderboard: UIButton! {
        didSet {
            leaderboard.layer.masksToBounds = false
            leaderboard.layer.cornerRadius = 8
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()
        setButtonImage(forKey: .isSoundEffectMuted, button: sound)
        setButtonImage(forKey: .isSoundtrackMuted, button: music)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    func changeValueUserDefaults(forKey: AudioConfig, button: UIButton) {
        if UserDefaults.standard.bool(forKey: forKey.rawValue) {
            UserDefaults.standard.setValue(false, forKey: forKey.rawValue)
            button.setImage(UIImage(named: forKey.rawValue+"_deactive"), for: .normal)
        } else {
            UserDefaults.standard.setValue(true, forKey: forKey.rawValue)
            button.setImage(UIImage(named: forKey.rawValue+"_active"), for: .normal)
        }
        
        UserDefaults.standard.synchronize()
        print(UserDefaults.standard.bool(forKey: forKey.rawValue))
    }
    
    func setButtonImage(forKey: AudioConfig, button: UIButton) {
        if !UserDefaults.standard.bool(forKey: forKey.rawValue) {
            button.setImage(UIImage(named: forKey.rawValue+"_deactive"), for: .normal)
        } else {
            button.setImage(UIImage(named: forKey.rawValue+"_active"), for: .normal)
        }
        
    }
    
    func authenticateLocalPlayer() {
    let localPlayer = GKLocalPlayer.local
    localPlayer.authenticateHandler = {(viewController, error) -> Void in

        if (viewController != nil) {
            self.present(viewController!, animated: true, completion: nil)
        }
        else {
            print((GKLocalPlayer.local.isAuthenticated))
        }
    }
}
    
    @IBAction func leaderboard(_ sender: Any) {
      let vc = GKGameCenterViewController(leaderboardID: "Leaderboard", playerScope: .global, timeScope: .allTime)
      vc.gameCenterDelegate = self
      present(vc, animated: true, completion: nil)
    }
}
