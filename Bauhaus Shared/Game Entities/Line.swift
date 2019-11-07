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
        let renderComponent = RenderComponent(node: SKNode())
        renderComponent.node.zPosition = CGFloat(RenderingPosition.line.rawValue)
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode(imageNamed: "lineOff"))
        spriteComponent.spriteNode.entity = self
        spriteComponent.spriteNode.name = "Line"
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
        
        switch lineOrientation {
        case .vertical : spriteComponent.spriteNode.zRotation = 0
        case .horizontal : spriteComponent.spriteNode.zRotation = .pi/2
        }
        
        // Game Logic Components
        let lightSwitchComponent = LightSwitchComponent(node: spriteComponent.spriteNode)
        lightSwitchComponent.stateMachine.enter(OffState.self)
        self.addComponent(lightSwitchComponent)
        
        let physicsComponent = PhysicsComponent(node: spriteComponent.spriteNode, categoryBitMask: .boardLine)
        self.addComponent(physicsComponent)
        
        let indexComponent = IndexComponent(x: index.x, y: index.y, orientation: lineOrientation)
        self.addComponent(indexComponent)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
