//
//  SpawnComponent.swift
//  SpitOTimeTests
//
//  Created by Paulo Uchôa on 08/04/21.
//

import XCTest
import SpriteKit
@testable import SpitOTime

class SpawnComponentTests: XCTestCase {

    func test_spawn_random_notNil() {
        let sut = SpawnComponent(sprites: ["llama1"])

        XCTAssertNotNil(sut.spawn())
    }
}
