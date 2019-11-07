//
//  Timer.swift
//  Bauhaus
//
//  Created by Rovane Moura on 29/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Timer : GKEntity {
    
    override init() {
        super.init()
        
        // Visual Components
        
        let renderComponent = RenderComponent(node: SKNode())
        renderComponent.node.zPosition = CGFloat(5)
//        renderComponent.node.position = CGPoint(x: 700, y: 1050)
        self.addComponent(renderComponent)
        
        let rectangleComponent = RectangleComponent(color: .black,
                                                    size: CGSize(width: 100, height: 1100),
                                                    position: .zero)
        renderComponent.node.addChild(rectangleComponent.shapeNode)
        self.addComponent(rectangleComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
//        self.component(ofType: RenderComponent.self)?.node.position.y -= 1
    }
    
}
