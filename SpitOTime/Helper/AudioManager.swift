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
    case background = "Background"
    case backgroundLoop = "BackgroundLoop"
    case gameOver = "GameOver"
    case menuBackground = "MenuBackground"
    static let soundExtension = "mp3"
}

enum AudioConfig: String {
    case isSoundtrackMuted = "isSoundtrackMuted"
    case isSoundEffectMuted = "isSoundEffectMuted"
}

class AudioManager {
    
    var audioPlayer: AVAudioPlayer?
    var isSoundtrackMuted: Bool
    var isSoundEffectMuted: Bool
    
    init() {
        isSoundtrackMuted = UserDefaults.standard.bool(forKey: AudioConfig.isSoundtrackMuted.rawValue)
        isSoundEffectMuted = UserDefaults.standard.bool(forKey: AudioConfig.isSoundEffectMuted.rawValue)
    }
    
    func getSKAudioNode(_ name: SoundName) -> SKAudioNode? {
        if !isSoundEffectMuted {
            let audioNode = SKAudioNode(fileNamed: name.rawValue)
            return audioNode
        }
        return  nil
    }
    
    func stopSKAudioNode(_ audioNode: SKAudioNode?) {
        if !isSoundEffectMuted {
            audioNode?.run(SKAction.stop())
        }
    }
    
    func playSKAudioNode(_ name: SoundName) -> SKAction? {
        if isSoundEffectMuted == false {
            SKAction.playSoundFileNamed(name.rawValue, waitForCompletion: false)
        }
        return nil
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }

    func playSound(named: SoundName, numberOfLoop: Int = 0, volume: Float = 1.0) {
        if isSoundEffectMuted == false {
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
}
