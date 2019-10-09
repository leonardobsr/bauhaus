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
        self.dotGrid = []
        self.horizontalLineGrid = []
        self.verticalLineGrid = []
        
        super.init()
    }
    
    func setGrid(width: Int, height: Int) {
        var line : [Dot]

        for _ in 0 ..< height {
            line = []
            for _ in 0 ..< width {
                let newDot = Dot()
                if let renderComponent = newDot.component(ofType: RenderComponent.self) {
                    renderComponent.node.position = CGPoint(x: CGFloat(0), y: CGFloat(0))
                }
                line.append(newDot)
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
