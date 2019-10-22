//
//  Background.swift
//  Bauhaus
//
//  Created by Rovane Moura on 07/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Background : GKEntity {
    
    init(position: CGPoint) {
        super.init()
        
        let renderComponent = RenderComponent(node: SKNode())
        renderComponent.node.position = position
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode(imageNamed: "background"))
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
