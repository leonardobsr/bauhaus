//
//  Direction.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

enum Direction {
    case none, up, down, left, right
    
    func opposite() -> Direction {
        switch self {
        case .none : return .none
        case .up : return .down
        case .down : return .up
        case .left : return .right
        case .right : return .left
        }
    }
    
    func axis() -> Axis {
        switch self {
        case .none : return .none
        case .up : return .Y
        case .down : return .Y
        case .left : return .X
        case .right : return .X
        }
    }
}

enum Axis {
    case none, X, Y
}

enum RenderingPosition : Int {
    case background = 0
    case board = 1
    case dot = 2
    case box = 3
    case line = 4
    case piece = 5
    case button = 6
    case timer = 7
}
