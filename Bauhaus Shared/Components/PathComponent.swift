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
    var pathMatrix : [[Int]]
    
    init(pathType: PathType) {
        self.pathType = pathType
        self.pathMatrix = [[]]
        
        super.init()
        
        self.pathMatrix = buildPathMatrix(pathType: pathType)
    }
    
    func buildPathMatrix(pathType: PathType) -> [[Int]]{
        return [[]]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
