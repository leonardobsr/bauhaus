//
//  Piece.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Piece : GKEntity {
    
    init(pathType: PathType, edgeSize: Int, pathSprite: PathSprite) {
        super.init()
        
        // Visual Components
        let renderComponent = RenderComponent(node: SKNode())
        renderComponent.node.entity = self
        renderComponent.node.zPosition = 2
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode())
        spriteComponent.spriteNode.entity = self
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
                
        // Game Logic Components
        let pathComponent = PathComponent(pathType: pathType, edgeSize: edgeSize, pathSprite: pathSprite)
        pathComponent.drawingNode.setScale(1.3)
        pathComponent.drawingNode.entity = self
        renderComponent.node.addChild(pathComponent.drawingNode)
        self.addComponent(pathComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
