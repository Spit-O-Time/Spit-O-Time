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
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: 9000)
        let scene: SKScene = GameScene(size: size)
        scene.scaleMode = .aspectFill
        skView.showsPhysics = true
        skView.presentScene(scene)
    }

}
