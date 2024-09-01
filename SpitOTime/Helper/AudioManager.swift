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
    
    static let shared = AudioManager()
    
    private init() { }
    
    private var audioPlayer: AVAudioPlayer?
    
    func stop() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }

    func pause() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.pause()
    }

    func resume() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.play()
    }

    func playSound(named: Assets.Sound, loop: Bool = false, volume: Float = 1.0) {
        if let url: URL = Bundle.main.url(forResource: named.rawValue, withExtension: Assets.Sound.fileExtension) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
                audioPlayer?.numberOfLoops = loop ? -1 : 1
                audioPlayer?.volume = volume
                audioPlayer?.play()
            } catch { }
        }
    }
}
