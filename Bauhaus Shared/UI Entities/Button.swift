//
//  Button.swift
//  Bauhaus
//
//  Created by Rovane Moura on 07/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Button : GKEntity {
    
    init(position: CGPoint, sprite: String) {
        super.init()
        
        let renderComponent = RenderComponent(node: SKNode())
        renderComponent.node.zPosition = CGFloat(RenderingPosition.button.rawValue)
        renderComponent.node.posByScreen(x: position.x, y: position.y)
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode(imageNamed: sprite))
        renderComponent.node.addChild(spriteComponent.spriteNode)
        spriteComponent.spriteNode.entity = self
        self.addComponent(spriteComponent)
        
        let tapComponent = TapComponent()
        self.addComponent(tapComponent)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
