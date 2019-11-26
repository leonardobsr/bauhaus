//
//  Timer.swift
//  Bauhaus
//
//  Created by Rovane Moura on 29/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Timer : GKEntity {
    
    var isRunning = false
    var originalPosition : CGPoint = .zero
    
    init(position: CGPoint) {
        self.originalPosition = position
        
        super.init()
        
        // Visual Components
        let rectangleComponent = RectangleComponent(color: .black,
                                                    size: CGSize(width: 100, height: 1100),
                                                    position: .zero)
        rectangleComponent.shapeNode.posByScreen(x: position.x, y: position.y)
        rectangleComponent.shapeNode.zPosition = CGFloat(RenderingPosition.timer.rawValue)
        rectangleComponent.shapeNode.entity = self
        rectangleComponent.shapeNode.name = "Timer"
        self.addComponent(rectangleComponent)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func update(deltaTime seconds: TimeInterval) {
        if isRunning { self.component(ofType: RectangleComponent.self)?.shapeNode.position.y -= 0.5 }
    }
    
    func stop() { self.isRunning = false }
    
    func start() { self.isRunning = true }
    
    func reset() {
        self
            .component(ofType: RectangleComponent.self)?
            .shapeNode.posByScreen(x: self.originalPosition.x,
                                   y: self.originalPosition.y)
        self.start()
    }
    
}
