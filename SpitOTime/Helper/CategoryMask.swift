//
//  CategoryMask.swift
//  SpitOTime
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import Foundation

enum CategoryMask: UInt32 {
    case spit = 0b01
    case enemy = 0b11
    case obstacle = 0b10
}
