//
//  Dot.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Dot : GKEntity {
        
    override init() {
        super.init()

        // Visual Components
        
        let renderComponent = RenderComponent()
        renderComponent.node.zPosition = CGFloat(RenderingPosition.dot.rawValue)
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode())
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
        
        // Game Logic Components
        
        let connectionComponent = ConnectionComponent()
        self.addComponent(connectionComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
