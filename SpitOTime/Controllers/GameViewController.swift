//
//  GameViewController.swift
//  SpitOTime
//
//  Created by Rodrigo Silva Ribeiro on 05/03/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let skView = SKView()

    override func loadView() {
        super.loadView()
        self.view = skView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene: SKScene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: 25000))
        scene.scaleMode = .aspectFill
        skView.showsPhysics = true
        skView.showsFPS = true
        skView.presentScene(scene)
    }

}
