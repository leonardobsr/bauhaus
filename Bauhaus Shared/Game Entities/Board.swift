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
        let renderComponent = RenderComponent(spriteNode: SKSpriteNode())
        renderComponent.spriteNode.zPosition = CGFloat(RenderingPosition.board.rawValue)
        renderComponent.spriteNode.size = CGSize(width: 0.8 * frame.height, height: 0.8 * frame.height)
        renderComponent.spriteNode.color = .white
        renderComponent.spriteNode.entity = self
        renderComponent.spriteNode.name = "Board"
        self.addComponent(renderComponent)
        
        // Game Logic Components
        let gridComponent = GridComponent(gridNode: SKNode())
        renderComponent.spriteNode.addChild(gridComponent.gridNode)
        self.addComponent(gridComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
