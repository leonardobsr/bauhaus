//
//  PathComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 08/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class PathComponent : GKComponent {
    
    var pathSprite : PathSprite
    var sprite : SKSpriteNode
    var structurePoints : [CGPoint]
        
    init(pathSprite: PathSprite, sprite: SKSpriteNode) {
        self.pathSprite = pathSprite
        
        switch pathSprite {
        case .I2 : self.structurePoints = [CGPoint(x: 0, y: 15), CGPoint(x: 0, y: -15)]
            
        case .L1 : self.structurePoints = [CGPoint(x: -15, y: 0), CGPoint(x: 0, y: 15)]
            
        case .L2 : self.structurePoints = [CGPoint(x: -30, y: 15), CGPoint(x: -30, y: -15),
                                           CGPoint(x: 15, y: 30), CGPoint(x: -15, y: 30)]
            
        case .U1 : self.structurePoints = [CGPoint(x: -15, y: 0), CGPoint(x: 0, y: 15), CGPoint(x: 15, y: 0)]
            
        case .U2 : self.structurePoints = [CGPoint(x: -30, y: 15), CGPoint(x: -30, y: -15),
                                           CGPoint(x: 15, y: 30), CGPoint(x: -15, y: 30),
                                           CGPoint(x: 30, y: 15), CGPoint(x: 30, y: -15)]
            
        case .T1 : self.structurePoints = [.zero, CGPoint(x: -15, y: 15), CGPoint(x: 15, y: 15)]
            
        case .T2 : self.structurePoints = [CGPoint(x: 0, y: -15), CGPoint(x: 0, y: 15),
                                           CGPoint(x: -15, y: 30), CGPoint(x: 15, y: 30),
                                           CGPoint(x: -45, y: 30), CGPoint(x: 45, y: 30)]
            
        case .Z1 : self.structurePoints = [.zero, CGPoint(x: -15, y: -15), CGPoint(x: 15, y: 15)]
            
        case .Z2 : self.structurePoints = [CGPoint(x: 0, y: -15), CGPoint(x: 0, y: 15),
                                           CGPoint(x: -15, y: -30), CGPoint(x: 15, y: 30),
                                           CGPoint(x: -45, y: -30), CGPoint(x: 45, y: 30)]
            
        default : self.structurePoints = [.zero]
        }
        
        self.sprite = sprite
        
//        structurePoints.forEach {
//            let shape = SKShapeNode(circleOfRadius: 5)
//            shape.position = $0
//            sprite.addChild(shape)
//        }
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//class PathComponent : GKComponent {
//
//    var pathType : PathType
//    var edgeSize : Int
//    var pathMatrix : [[Int]]
//
//    var drawingNode : SKNode
//
//    init(pathType: PathType, edgeSize: Int, pathSprite: PathSprite) {
//        self.pathType = pathType
//        self.edgeSize = edgeSize
//        self.pathMatrix = [[]]
//        self.drawingNode = SKSpriteNode(imageNamed: pathSprite.rawValue)
//
//        super.init()
//
////        self.pathMatrix = buildPathMatrix()
//    }
//
//    func buildPathMatrix() -> [[Int]] {
//        var newPathMatrix : [[Int]] = []
//
//        switch self.pathType {
//        case .I :
//            newPathMatrix = Array(repeating: Array(repeating: 1, count: edgeSize + 1), count: 1)
//
//        case .L :
//            newPathMatrix = Array(repeating: Array(repeating: 0, count: edgeSize + 1), count: edgeSize + 1)
//
//            let height = newPathMatrix.count
//            let width = newPathMatrix[height - 1].count
//
//            for i in 0 ..< height { newPathMatrix[i][0] = 1 }
//            for j in 0 ..< width { newPathMatrix[height - 1][j] = 1 }
//
//        case .U :
//            newPathMatrix = Array(repeating: Array(repeating: 0, count: edgeSize + 1), count: edgeSize + 1)
//
//            let height = newPathMatrix.count
//            let width = newPathMatrix[height - 1].count
//
//            for i in 0 ..< height { newPathMatrix[i][0] = 1 ; newPathMatrix[i][width - 1] = 1 }
//            for j in 0 ..< width { newPathMatrix[height - 1][j] = 1 }
//
//        case .T :
//            newPathMatrix = Array(repeating: Array(repeating: 0, count: (edgeSize * 2) + 1 ), count: edgeSize + 1)
//
//            let height = newPathMatrix.count
//            let width = newPathMatrix[height - 1].count
//            let mid = (width % 2 == 0) ? (width / 2) : ((width + 1) / 2)
//
//            for i in 0 ..< height { newPathMatrix[i][mid - 1] = 1 }
//            for j in 0 ..< width { newPathMatrix[0][j] = 1 }
//
//        case .Z :
//            newPathMatrix = Array(repeating: Array(repeating: 0, count: (edgeSize * 2) + 1), count: edgeSize + 1)
//
//            let height = newPathMatrix.count
//            let width = newPathMatrix[height - 1].count
//            let mid = (width % 2 == 0) ? (width / 2) : ((width + 1) / 2)
//
//            for i in 0 ..< height { newPathMatrix[i][mid - 1] = 1 }
//            for j in 0 ..< width {
//                if j < (mid - 1) {
//                    newPathMatrix[0][j] = 1
//                } else {
//                    newPathMatrix[height - 1][j] = 1
//                }
//
//            }
//        }
//
//        return newPathMatrix
//    }
//
//    func drawPathMatrix() {
////        var firstX = -1
////        var firstY = -1
////
////        for i in 0 ... pathMatrix.count {
////            for j in 0 ... pathMatrix[0].count {
////                if pathMatrix[i][j] == 1 {
////                    firstX = i
////                    firstY = j
////                    break
////                }
////            }
////            if firstX != -1 && firstY != -1 { break }
////        }
//
//        var newPathMatrix : [[Dot?]] = []
//
//        switch self.pathType {
//        case .I :
//            newPathMatrix = Array(repeating: Array(repeating: Dot(), count: edgeSize + 1), count: 1)
//
//        case .L :
//            newPathMatrix = Array(repeating: Array(repeating: nil, count: edgeSize + 1), count: edgeSize + 1)
//
//            let height = newPathMatrix.count
//            let width = newPathMatrix[height - 1].count
//
//            for i in 0 ..< height { newPathMatrix[i][0] = Dot() }
//            for j in 0 ..< width { newPathMatrix[height - 1][j] = Dot() }
//
//        case .U :
//            newPathMatrix = Array(repeating: Array(repeating: nil, count: edgeSize + 1), count: edgeSize + 1)
//
//            let height = newPathMatrix.count
//            let width = newPathMatrix[height - 1].count
//
//            for i in 0 ..< height { newPathMatrix[i][0] = Dot() ; newPathMatrix[i][width - 1] = Dot() }
//            for j in 0 ..< width { newPathMatrix[height - 1][j] = Dot() }
//
//        case .T :
//            newPathMatrix = Array(repeating: Array(repeating: nil, count: (edgeSize * 2) + 1 ), count: edgeSize + 1)
//
//            let height = newPathMatrix.count
//            let width = newPathMatrix[height - 1].count
//            let mid = (width % 2 == 0) ? (width / 2) : ((width + 1) / 2)
//
//            for i in 0 ..< height { newPathMatrix[i][mid - 1] = Dot() }
//            for j in 0 ..< width { newPathMatrix[0][j] = Dot() }
//
//        case .Z :
//            newPathMatrix = Array(repeating: Array(repeating: nil, count: (edgeSize * 2) + 1), count: edgeSize + 1)
//
//            let height = newPathMatrix.count
//            let width = newPathMatrix[height - 1].count
//            let mid = (width % 2 == 0) ? (width / 2) : ((width + 1) / 2)
//
//            for i in 0 ..< height { newPathMatrix[i][mid - 1] = Dot() }
//            for j in 0 ..< width {
//                if j < (mid - 1) {
//                    newPathMatrix[0][j] = Dot()
//                } else {
//                    newPathMatrix[height - 1][j] = Dot()
//                }
//
//            }
//        }
//
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
