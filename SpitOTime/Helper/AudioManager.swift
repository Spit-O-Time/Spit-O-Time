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

class AudioManager: NSObject {
    
    public static let shared = AudioManager()

    public let didFinishPlaying = Notification.Name("didFinishPlaying")
    public var latestPlayedSound: Assets.Sound?
    private var audioPlayer: AVAudioPlayer?
    
    private override init() { }

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
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = loop ? -1 : 0
                audioPlayer?.volume = volume
                audioPlayer?.delegate = self
                audioPlayer?.play()
                latestPlayedSound = getCurrentPlayingSound()
            } catch { }
        }
    }

    func getCurrentPlayingSound() -> Assets.Sound? {
        if let filename = audioPlayer?.url?.lastPathComponent 
            .replacingOccurrences(
                of: "." + Assets.Sound.fileExtension,
                with: String()
            ) {
            return Assets.Sound(rawValue: filename)
        }
        return nil
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(
            name: didFinishPlaying,
            object: false
        )
    }
}
