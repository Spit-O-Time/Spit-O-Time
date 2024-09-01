//
//  AudioManager.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 18/03/21.
//

import SpriteKit
import AVFoundation

enum AudioConfig: String {
    case isSoundtrackMuted
    case isSoundEffectMuted
}

class AudioManager {
    
    var audioPlayer: AVAudioPlayer?
    var defaultVolume: Float = 1.0
    
    @discardableResult
    func stopSound() -> Bool {
        guard let audioPlayer = audioPlayer else { return false }
        audioPlayer.stop()
        return true
    }

    func playSound(named: Assets.Sound, loop: Bool = false) {
        if let url: URL = Bundle.main.url(forResource: named.rawValue, withExtension: Assets.Sound.fileExtension) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
                audioPlayer?.numberOfLoops = loop ? -1 : 1
                audioPlayer?.volume = defaultVolume
                audioPlayer?.play()
            } catch { }
        }
    }
}
