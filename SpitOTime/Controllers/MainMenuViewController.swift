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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
