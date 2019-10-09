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
        
        let renderComponent = RenderComponent()
        renderComponent.node.zPosition = CGFloat(RenderingPosition.box.rawValue)
        self.addComponent(renderComponent)
        
        let rectangleComponent = RectangleComponent(color: color, size: size, position: position)
        renderComponent.node.addChild(rectangleComponent.shapeNode)
        self.addComponent(rectangleComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
