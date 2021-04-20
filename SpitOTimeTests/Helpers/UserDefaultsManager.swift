//
//  UserDefaultsManager.swift
//  SpitOTimeTests
//
//  Created by Vinicius Mesquita on 09/04/21.
//
import XCTest
@testable import  SpitOTime


class UserDefaultsManagerTests: XCTestCase {
    
    func teste_verifyState_isFirstTime_false() {

        let expectation = self.expectation(description: #function)
        var result: UserLoggedState? = .firstTimePlaying
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.notFirstTime.rawValue)
        
        UserDefaultsManager.verifyState { state in
            result = state
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        XCTAssertEqual(result, UserLoggedState.notFirstTimePlaying)
    }
    
    func teste_verifyState_isFirstTime_true() {

        let expectation = self.expectation(description: #function)
        var result: UserLoggedState? = .notFirstTimePlaying
        UserDefaults.standard.setValue(false, forKey: UserDefaultsKey.notFirstTime.rawValue)
        UserDefaultsManager.verifyState { state in
            result = state
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        XCTAssertEqual(result, UserLoggedState.firstTimePlaying)
    }
    
    
}
