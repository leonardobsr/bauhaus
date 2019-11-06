//
//  VisualResponseComponent.swift
//  Bauhaus iOS
//
//  Created by Rovane Moura on 21/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class VisualResponseComponent : GKComponent {

    var spriteNode : SKSpriteNode

    init(spriteNode: SKSpriteNode, spriteHighlighted: String) {
        self.spriteNode = spriteNode
        print("troca de sprite")
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setOpacity(opacity: CGFloat) {
        self.spriteNode.alpha = opacity;
    }

    func setTexture(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        self.spriteNode.texture = texture
        self.spriteNode.size = texture.size()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
}
