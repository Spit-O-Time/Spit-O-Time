//
//  AudioManager.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 18/03/21.
//

import SpriteKit
import AVFoundation

enum SoundName: String {
    case spit = "LlamaSpit"
    case background = "MenuBackground"
    case gameOver = "GameOver"
    
    static let soundExtension = "mp3"
}

class AudioManager {
    
    var audioPlayer: AVAudioPlayer?
    
    func getSKAudioNode(name: SoundName) -> SKAudioNode {
        return SKAudioNode(fileNamed: name.rawValue)
    }
    
    func stopSKAudioNode(audioNode: SKAudioNode) {
        audioNode.run(SKAction.stop())
    }
    
    func play(_ name: SoundName) -> SKAction {
        SKAction.playSoundFileNamed(name.rawValue, waitForCompletion: false)
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }

    func playSound(named: SoundName, numberOfLoop: Int = 0, volume: Float = 1.0) {
        if let url: URL = Bundle.main.url(forResource: named.rawValue, withExtension: SoundName.soundExtension) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
                audioPlayer?.numberOfLoops = numberOfLoop
                audioPlayer?.volume = volume
                audioPlayer?.play()
            } catch {
                fatalError()
            }
        }
    }
}
