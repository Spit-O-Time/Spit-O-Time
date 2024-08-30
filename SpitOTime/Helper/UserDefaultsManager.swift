//
//  UserDefaultsManager.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 24/03/21.
//

import Foundation

enum UserDefaultsKey: String {
   case isFirstTimePlaying
}

enum AudioConfigKey: String {
    case isBackgroundSoundMuted
    case isSoundEffectMuted
}

struct UserDefaultsManager {

    static var isFirstTimePlaying: Bool {
        return UserDefaults.standard.bool(
            forKey: UserDefaultsKey.isFirstTimePlaying.rawValue
        )
    }

    static var isBackgroundSoundMuted: Bool {
        return UserDefaults.standard.bool(
            forKey: AudioConfigKey.isBackgroundSoundMuted.rawValue
        )
    }

    static var isSoundEffectMuted: Bool {
        return UserDefaults.standard.bool(
            forKey: AudioConfigKey.isSoundEffectMuted.rawValue
        )
    }
}

extension UserDefaultsManager {

    static func setFirstTime() {
        UserDefaults.standard.set(
            true,
            forKey: UserDefaultsKey.isFirstTimePlaying.rawValue
        )
    }
    
    
    static func toggleMuteBackgroundSound() {
        UserDefaults.standard.set(
            !isBackgroundSoundMuted,
            forKey: AudioConfigKey.isBackgroundSoundMuted.rawValue
        )
    }

    static func toggleSoundEffectSound() {
        UserDefaults.standard.set(
            !isSoundEffectMuted,
            forKey: AudioConfigKey.isSoundEffectMuted.rawValue
        )
    }
}
