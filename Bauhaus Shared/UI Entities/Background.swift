//
//  Background.swift
//  Bauhaus
//
//  Created by Rovane Moura on 07/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Background : GKEntity {
    
    override init() {
        super.init()
        
        let renderComponent = RenderComponent()
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode())
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
