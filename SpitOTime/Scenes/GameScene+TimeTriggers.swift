//
//  GameScene+TimeTriggers.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita Coelho on 07/09/24.
//

import SpriteKit

extension GameScene {

    // MARK: Time Events
    func startGameTimer() {
        Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(startGameTrigger),
            userInfo: nil,
            repeats:  false
        )
    }
    
    func difficultyTimer() {
        Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(difficultyTrigger),
            userInfo: nil,
            repeats: true
        )
    }
    
    func updateScoreTimer() {
        Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateScorePoints),
            userInfo: nil,
            repeats:  true
        )
    }

    // MARK: Triggers
    @objc func startGameTrigger() {
        guard !isPaused else { return }
        self.isPlaying = true
        self.stateMachine?.enter(PlayingState.self)
        let playSpitSound = SKAction.playSoundFileNamed(
            Assets.Sound.spit.rawValue, waitForCompletion: false
        )
        let spitNode = spit.component(ofType: SpitComponent.self)?.spriteNode
        spitNode?.run(playSpitSound)
        self.spitTail.isHidden = false
    }
    
    @objc func updateScorePoints() {
        guard isPlaying else { return }
        score = ScoreHandler(secondsOfPlaying: secondsOfPlaying).calculate()
        secondsOfPlaying += 1
    }

    @objc func difficultyTrigger() {
        if isPlaying && velocity < maxVelocity {
            velocity += 0.5
        }
    }
}
