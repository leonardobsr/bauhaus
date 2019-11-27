//
//  Piece.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Piece : GKEntity {
    
    init(pathSprite: PathSprite) {
        super.init()
        
        // Visual Components
        let renderComponent = RenderComponent(spriteNode: SKSpriteNode(imageNamed: pathSprite.rawValue))
        renderComponent.spriteNode.zPosition = CGFloat(RenderingPosition.piece.rawValue)
        renderComponent.spriteNode.entity = self
        renderComponent.spriteNode.name = "Piece"
        self.addComponent(renderComponent)
        
        renderComponent.spriteNode.setScale((SKViewSize!.height/SKViewSize!.width) * 2)
                
        // Game Logic Components
        let pathComponent = PathComponent(pathSprite: pathSprite, sprite: renderComponent.spriteNode)
        self.addComponent(pathComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
