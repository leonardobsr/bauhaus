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
        
        let renderComponent = RenderComponent(spriteNode: SKSpriteNode(imageNamed: sprite))
        renderComponent.spriteNode.posByScreen(x: position.x, y: position.y)
        renderComponent.spriteNode.zPosition = CGFloat(RenderingPosition.button.rawValue)
        renderComponent.spriteNode.entity = self
        renderComponent.spriteNode.name = "Button"
        self.addComponent(renderComponent)
                
        let tapComponent = TapComponent()
        self.addComponent(tapComponent)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
