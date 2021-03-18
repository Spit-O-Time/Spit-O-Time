//
//  AudioManager.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 18/03/21.
//

import SpriteKit

enum SoundName: String {
    case spit = "LlamaSpit.mp3"
    case background = "MenuBackground.mp3"
    case gameOver = "GameOver.mp3"
}

class AudioManager {
    
    func getSKAudioNode(name: SoundName) -> SKAudioNode {
        return SKAudioNode(fileNamed: name.rawValue)
    }
    
    func stopSKAudioNode(audioNode: SKAudioNode) {
        audioNode.run(SKAction.stop())
    }
}
