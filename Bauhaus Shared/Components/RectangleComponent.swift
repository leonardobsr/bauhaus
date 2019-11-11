//
//  RectangleComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 08/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class RectangleComponent : GKComponent {
    
    var shapeNode : SKShapeNode
    var color : UIColor
    
    init(color: UIColor, size: CGSize, position: CGPoint) {
        let rect = CGRect(x: position.x, y: position.y, width: size.width, height: size.height)
        self.shapeNode = SKShapeNode(rect: rect)
        self.shapeNode.fillColor = color
        self.shapeNode.strokeColor = .clear
        self.color = color
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
