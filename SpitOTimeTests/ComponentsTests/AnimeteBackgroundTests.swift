//
//  AnimeteBackgroundTests.swift
//  SpitOTimeTests
//
//  Created by Paulo Uchôa on 08/04/21.
//

import XCTest
import SpriteKit
@testable import SpitOTime

class AnimeteBackgroundTests: XCTestCase {

    func teste_updateBackground_ground_position() {
        
        let sceneCamera: SKCameraNode = {
            let camera = SKCameraNode()
            camera.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height+100)
            return camera
        }()
        
        let sut = AnimateBackgroundComponent(shooterAsset: "llama",
                                             backgroundAsset: "ground",
                                             leftBarrierAsset: "wallLeft",
                                             rightBarrierAsset: "wallRight")
    
        let grounds = sut.grounds
        
        sut.updateBackground(cameraNode: sceneCamera, velocity: 1.0)
        
        XCTAssertEqual(grounds[0].position.y, grounds[1].position.y + grounds[1].frame.height)
        
    }
    
    func teste_updateBackground_walls_position() {
        
        let sceneCamera: SKCameraNode = {
            let camera = SKCameraNode()
            camera.position = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height+5000)
            return camera
        }()
        
        let sut = AnimateBackgroundComponent(shooterAsset: "llama",
                                             backgroundAsset: "ground",
                                             leftBarrierAsset: "wallLeft",
                                             rightBarrierAsset: "wallRight")
    
        
        let wallRight = sut.wallRight
        let wallLeft = sut.wallLeft
        
        sut.updateBackground(cameraNode: sceneCamera, velocity: 1.0)
        
        XCTAssertEqual(wallRight[0].position.y, wallRight[1].position.y + wallRight[1].frame.height)
        XCTAssertEqual(wallLeft[0].position.y, wallLeft[1].position.y + wallLeft[1].frame.height)
        
    }

}
