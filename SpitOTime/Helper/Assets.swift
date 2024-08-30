//
//  Assets.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita Coelho on 30/08/24.
//

import Foundation

struct Assets {

    struct Icon {
        static let soundEffectDeactive = "sound_effect_deactive"
        static let soundEffectActive = "sound_effect_active"
        static let backgroundSoundActive = "music_background_active"
        static let backgroundSoundDeactive = "music_background_deactive"
    }

    enum Sound: String {
        case spit = "LlamaSpit"
        case background = "Background"
        case backgroundLoop = "BackgroundLoop"
        case gameOver = "GameOver"
        case menuBackground = "MenuBackground"
        case failedCase = "failedCase"
        static let fileExtension = "mp3"
    }
}
