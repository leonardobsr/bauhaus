//
//  GridComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 07/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class GridComponent : GKComponent {
    
    var gridNode : SKNode
    
    var dotGrid : [[Dot]]
    
    var horizontalLineGrid : [[Line]]
    
    var verticalLineGrid : [[Line]]
    
    override init() {
        self.gridNode = SKNode()
        self.dotGrid = [[]]
        self.horizontalLineGrid = [[]]
        self.verticalLineGrid = [[]]
    }
    
    func setGrid(width: Int, height: Int) {
        var line : [Dot]

        for _ in 0 ..< height {
            line = []
            for _ in 0 ..< width {
                line.append(Dot())
            }
            self.dotGrid.append(line)
        }
        
        // set hlines
        // set vlines
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
