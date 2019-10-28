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
        
        let spriteComponent = SpriteComponent(spriteNode:SKSpriteNode())
        spriteComponent.spriteNode.size = CGSize(width: 800, height: 800)
        spriteComponent.spriteNode.color = .white
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
        
        // Game Logic Components
        
        let gridComponent = GridComponent(gridNode: SKNode())
        let gridNode = gridComponent.gridNode
        spriteComponent.spriteNode.addChild(gridComponent.gridNode)
        if let board = gridNode.parent as? SKSpriteNode {
            gridNode.position = CGPoint(x: (board.position.x - board.size.width/2) + 100,
                                        y: (board.position.y - board.size.height/2) + 100)
        }
        self.addComponent(gridComponent)
        
        let boardComponent = BoardComponent()
        self.addComponent(boardComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
