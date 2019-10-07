//
//  SpriteComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class SpriteComponent : GKComponent {
    
    var spriteNode : SKSpriteNode
    
    init(spriteNode: SKSpriteNode) {
        self.spriteNode = spriteNode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
