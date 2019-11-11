//
//  Box.swift
//  Bauhaus
//
//  Created by Rovane Moura on 07/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Box : GKEntity {
    
    init(color: UIColor, size: CGSize, position: CGPoint) {
        super.init()
        
        // Visual Components
        let rectangleComponent = RectangleComponent(color: color, size: size, position: position)
        rectangleComponent.shapeNode.zPosition = CGFloat(RenderingPosition.box.rawValue)
        self.addComponent(rectangleComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
