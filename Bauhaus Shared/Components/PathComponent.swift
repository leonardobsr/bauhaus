//
//  PathComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 08/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class PathComponent : GKComponent {
    
    var pathType : PathType
    var edgeSize : Int
    var pathMatrix : [[Int]]
    
    init(pathType: PathType, edgeSize: Int) {
        self.pathType = pathType
        self.edgeSize = edgeSize
        self.pathMatrix = [[]]
        
        super.init()
        
        self.pathMatrix = buildPathMatrix()
    }
    
    func buildPathMatrix() -> [[Int]] {
        var newPathMatrix : [[Int]] = []
        
        switch self.pathType {
        case .I :
            newPathMatrix = Array(repeating: Array(repeating: 1, count: edgeSize + 1), count: 1)
            
        case .L :
            newPathMatrix = Array(repeating: Array(repeating: 0, count: edgeSize + 1), count: edgeSize + 1)
            
            let height = newPathMatrix.count
            let width = newPathMatrix[height - 1].count
            
            for i in 0 ..< height { newPathMatrix[i][0] = 1 }
            for j in 0 ..< width { newPathMatrix[height - 1][j] = 1 }
            
        case .U :
            newPathMatrix = Array(repeating: Array(repeating: 0, count: edgeSize + 1), count: edgeSize + 1)
            
            let height = newPathMatrix.count
            let width = newPathMatrix[height - 1].count
            
            for i in 0 ..< height { newPathMatrix[i][0] = 1 ; newPathMatrix[i][width - 1] = 1 }
            for j in 0 ..< width { newPathMatrix[height - 1][j] = 1 }
            
        case .T :
            newPathMatrix = Array(repeating: Array(repeating: 0, count: (edgeSize * 2) + 1 ), count: edgeSize + 1)
            
            let height = newPathMatrix.count
            let width = newPathMatrix[height - 1].count
            let mid = (width % 2 == 0) ? (width / 2) : ((width + 1) / 2)
            
            for i in 0 ..< height { newPathMatrix[i][mid - 1] = 1 }
            for j in 0 ..< width { newPathMatrix[0][j] = 1 }
            
        case .Z :
            newPathMatrix = Array(repeating: Array(repeating: 0, count: (edgeSize * 2) + 1), count: edgeSize + 1)
            
            let height = newPathMatrix.count
            let width = newPathMatrix[height - 1].count
            let mid = (width % 2 == 0) ? (width / 2) : ((width + 1) / 2)
            
            for i in 0 ..< height { newPathMatrix[i][mid - 1] = 1 }
            for j in 0 ..< width {
                if j < (mid - 1) {
                    newPathMatrix[0][j] = 1
                } else {
                    newPathMatrix[height - 1][j] = 1
                }
                
            }
        }
        
        return newPathMatrix
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
