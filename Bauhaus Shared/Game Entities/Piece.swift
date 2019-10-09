//
//  Piece.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Piece : GKEntity {
    
    init(pathType: PathType) {
        super.init()
        
        // Visual Components
        let renderComponent = RenderComponent()
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode())
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
                
        // Game Logic Components
        let pathComponent = PathComponent(pathType: pathType)
        self.addComponent(pathComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
