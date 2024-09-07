//
//  teste.swift
//  SpitOTime
//
//  Created by Paulo Uchôa on 09/03/21.
//

import UIKit

enum ScreenSize {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
}


enum ScreenPosition {
    static let center = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height/2)
    static let bottomCenter = CGPoint(x: ScreenSize.width/2, y: .zero)
    static let topCenter = CGPoint(x: .zero, y: ScreenSize.height/2)
    
    static let bottomLeft = CGPoint.zero
    static let bottomRight = CGPoint(x: ScreenSize.width, y: .zero)
    
    static let topLeft = CGPoint(x: .zero, y: ScreenSize.height)
    static let topRight = CGPoint(x: ScreenSize.width, y: .zero)
}
