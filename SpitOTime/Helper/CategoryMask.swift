//
//  CategoryMask.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import Foundation

enum CategoryMask: UInt32 {
    case spit = 0b01
    case llama = 0b10

    static func collides(bodyA: CategoryMask, bodyB: CategoryMask) -> UInt32 {
        return bodyA.rawValue | bodyB.rawValue
    }
}
