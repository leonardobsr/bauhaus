//
//  SpriteComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class RenderComponent : GKComponent {
    
    var spriteNode : SKSpriteNode
    
    init(spriteNode: SKSpriteNode) {
        self.spriteNode = spriteNode
        super.init()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setTexture(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        self.spriteNode.texture = texture
        self.spriteNode.size = texture.size()
    }
    
}
