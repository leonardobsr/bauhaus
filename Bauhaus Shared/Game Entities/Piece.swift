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
        renderComponent.node.zPosition = CGFloat(RenderingPosition.piece.rawValue)
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode(imageNamed: pathSprite.rawValue))
        spriteComponent.spriteNode.entity = self
        spriteComponent.spriteNode.name = "Piece"
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
                
        // Game Logic Components
//        let pathComponent = PathComponent(pathType: pathType, edgeSize: edgeSize, pathSprite: pathSprite)
//        pathComponent.drawingNode.entity = self
//        pathComponent.drawingNode.name = "Piece"
//        renderComponent.node.addChild(pathComponent.drawingNode)
//        self.addComponent(pathComponent)
        
        let physicsComponent = PhysicsComponent(node: spriteComponent.spriteNode, categoryBitMask: .gamePiece)
        self.addComponent(physicsComponent)
        spriteComponent.spriteNode.setScale(2)
        
        let pathComponent = PathComponent(pathSprite: pathSprite, sprite: spriteComponent.spriteNode)
        self.addComponent(pathComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
