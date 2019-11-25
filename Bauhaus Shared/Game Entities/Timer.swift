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
        let rectangleComponent = RectangleComponent(color: .black,
                                                    size: CGSize(width: 100, height: 1100),
                                                    position: .zero)
        rectangleComponent.shapeNode.zPosition = CGFloat(RenderingPosition.timer.rawValue)
        rectangleComponent.shapeNode.entity = self
        rectangleComponent.shapeNode.name = "Timer"
        self.addComponent(rectangleComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.component(ofType: RectangleComponent.self)?.shapeNode.position.y -= 0.2
    }
    
}
