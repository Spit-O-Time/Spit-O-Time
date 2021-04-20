//
//  UserDefaultsManager.swift
//  SpitOTimeTests
//
//  Created by Vinicius Mesquita on 09/04/21.
//
import XCTest
@testable import SpitOTime
import SpriteKit
import AVFoundation

class AudioManagerManagerTests: XCTestCase {
    
    func teste_stopAudiNode_true() {
        UserDefaults.standard.setValue(false, forKey: AudioConfig.isSoundEffectMuted.rawValue)
        let sut = AudioManager()

        let result = sut.stopSKAudioNode(SKAudioNode())
        XCTAssertTrue(result)
    }
    
    func teste_stopAudiNode_false() {
        UserDefaults.standard.setValue(true, forKey: AudioConfig.isSoundEffectMuted.rawValue)
        let sut = AudioManager()
        
        let result = sut.stopSKAudioNode(nil)
        
        XCTAssertFalse(result)
        
    }
    
    func teste_getNode_Nil() {
        UserDefaults.standard.setValue(true, forKey: AudioConfig.isSoundEffectMuted.rawValue)
        let sut = AudioManager()

        let result = sut.getSKAudioNode(.failedCase)

        XCTAssertNil(result)
    }
    
    func teste_stopSound_true() {
        UserDefaults.standard.setValue(true, forKey: AudioConfig.isSoundEffectMuted.rawValue)
        let sut = AudioManager()
        let result = sut.stopSound()
        XCTAssertFalse(result)
    }
    
}
