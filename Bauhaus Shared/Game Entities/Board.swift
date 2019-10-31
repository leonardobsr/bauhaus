//
//  Board.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Board : GKEntity {
    
    init(frame: CGRect) {
        super.init()
        
        // Visual Components
        
        let renderComponent = RenderComponent(node: SKNode())
        renderComponent.node.zPosition = CGFloat(RenderingPosition.board.rawValue)
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode())
        spriteComponent.spriteNode.size = CGSize(width: 0.7 * frame.height, height: 0.7 * frame.height)
        spriteComponent.spriteNode.color = .white
        renderComponent.node.addChild(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
        
        // Game Logic Components
        
        let gridComponent = GridComponent(gridNode: SKNode())
        spriteComponent.spriteNode.addChild(gridComponent.gridNode)
        self.addComponent(gridComponent)
        
        let boardComponent = BoardComponent()
        self.addComponent(boardComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
