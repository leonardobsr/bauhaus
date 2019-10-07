//
//  Board.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Board : GKEntity {
    
    override init() {
        // Visual Components
        
        let renderComponent = RenderComponent()
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode())
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
        
        // Game Logic Components
        
        let gridComponent = GridComponent()
        self.addComponent(gridComponent)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
