//
//  Line.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

enum LineOrientation {
    case vertical, horizontal
}

class Line : GKEntity {
    
    init(_ lineOrientation: LineOrientation, index: (x: Int, y: Int)) {
        super.init()
        
        // Visual Components
        let renderComponent = RenderComponent(spriteNode: SKSpriteNode(imageNamed: "lineOff"))
        renderComponent.spriteNode.zPosition = CGFloat(RenderingPosition.line.rawValue)
        renderComponent.spriteNode.entity = self
        renderComponent.spriteNode.name = "Line"
        self.addComponent(renderComponent)
        
        switch lineOrientation {
        case .vertical : renderComponent.spriteNode.zRotation = 0
        case .horizontal : renderComponent.spriteNode.zRotation = .pi/2
        }
        
        // Game Logic Components
        let lightSwitchComponent = LightSwitchComponent(node: renderComponent.spriteNode)
        lightSwitchComponent.stateMachine.enter(OffState.self)
        self.addComponent(lightSwitchComponent)
        
        let indexComponent = IndexComponent(x: index.x, y: index.y, orientation: lineOrientation)
        self.addComponent(indexComponent)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
