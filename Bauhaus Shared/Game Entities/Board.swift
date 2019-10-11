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
        super.init()
        
        // Visual Components
        
        let renderComponent = RenderComponent(node: SKNode())
        renderComponent.node.zPosition = CGFloat(RenderingPosition.board.rawValue)
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode())
        spriteComponent.spriteNode.position = CGPoint(x: -150, y: 0)
        spriteComponent.spriteNode.size = CGSize(width: 900, height: 900)
        spriteComponent.spriteNode.color = .white
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
        
        // Game Logic Components
        
        let gridComponent = GridComponent(gridNode: SKNode())
        gridComponent.gridNode.position = CGPoint(x: -500, y: -350)
        renderComponent.node.addChild(gridComponent.gridNode)
        self.addComponent(gridComponent)
        
        let boardComponent = BoardComponent()
        self.addComponent(boardComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
