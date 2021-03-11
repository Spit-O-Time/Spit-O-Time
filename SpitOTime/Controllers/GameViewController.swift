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

    let skView = SKView(frame: UIScreen.main.bounds)

    override func loadView() {
        super.loadView()
        self.view = skView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene: SKScene = GameScene()
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

}
