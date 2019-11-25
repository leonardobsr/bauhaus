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
        let renderComponent = RenderComponent(spriteNode: SKSpriteNode(imageNamed: "dot"))
        renderComponent.spriteNode.zPosition = CGFloat(RenderingPosition.dot.rawValue)
        renderComponent.spriteNode.entity = self
        renderComponent.spriteNode.name = "Dot"
        self.addComponent(renderComponent)
        
        // Game Logic Components
        let connectionComponent = ConnectionComponent()
        self.addComponent(connectionComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
