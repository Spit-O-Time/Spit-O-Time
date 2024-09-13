//
//  GameScene+SetupNodes.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita Coelho on 07/09/24.
//

import SpriteKit

extension GameScene {

    func setupNodes() {
        setupTextLabelNode()
        setupBackgroundNode()
        setupSpitNode()
    }

    func setupBackgroundNode() {
        guard let backgrounds = background.component(ofType: AnimateBackgroundComponent.self) else {
            return
        }
        
        let ground = backgrounds.grounds
        let leftWall = backgrounds.wallLeft
        let rightWall = backgrounds.wallRight
        let llama = backgrounds.shooterCharacter
        
        addChild(llama)
        ground.forEach { addChild($0) }
        leftWall.forEach { addChild($0) }
        rightWall.forEach { addChild($0) }
    }

    func setupSpitNode() {
        guard let spitSpriteNode = spit
            .component(ofType: SpitComponent.self)?
            .spriteNode else { return }

        self.spitTail = SKEmitterNode(fileNamed: "SpitParticle.sks")
        self.spitTail.position = spitSpriteNode.position
        self.spitTail.isHidden = true
        addChild(self.spitTail)
        addChild(spitSpriteNode)
    }

    func setupTextLabelNode() {
        scoreLabel = SKLabelNode(fontNamed: "Orange Slices")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = .cardBackgroundColor
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.zPosition = 5
        scoreLabel.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height - 120)
        addChild(scoreLabel)
    }
    
}
