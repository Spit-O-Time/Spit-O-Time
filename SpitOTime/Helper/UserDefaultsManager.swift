//
//  UserDefaultsManager.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 24/03/21.
//

import Foundation

enum UserLoggedState {
    case firstTimePlaying
    case notFirstTimePlaying
}

enum UserDefaultsKey: String {
   case notFirstTime
    
    // others atributes are added here
}

struct UserDefaultsManager {
    
    
    static func verifyState(completion: (UserLoggedState) -> ()) {
        
        let userDefaults = UserDefaults.standard
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.notFirstTime.rawValue) != true {
            
            userDefaults.set(true, forKey: UserDefaultsKey.notFirstTime.rawValue)
            completion(.firstTimePlaying)
            
        } else {
            completion(.notFirstTimePlaying)
        }
    }
    
}
