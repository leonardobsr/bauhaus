//
//  Button.swift
//  Bauhaus
//
//  Created by Rovane Moura on 07/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//
//  Menu principal - troca de sprite
//  Menu Cor - troca o alfa de 0.5 para 1
//  Menu de Jogo - sofre set scale

import GameplayKit

enum ButtonType {
    case changeSprite(spriteDefault: String, spriteHighlighted: String)
    case changeAlpha(alphaDefault: CGFloat, alphaHighlighted: CGFloat)
    case changeScale(scaleDefault: CGFloat, scaleHighlighted: CGFloat)
}

enum ButtonStates {
    case idle
    case pressed
}

class Button : GKEntity {
    
    var state: ButtonStates? {
        didSet {
            switch state {
            case .none:
                break
            case .idle:
                print("idle")
                break
            case .pressed:
                print("pressed")
                break
            }
        }
    }
    
    init(type: ButtonType, position: CGPoint, sprite: String) {
        super.init()
        
        let renderComponent = RenderComponent(node: SKNode())
        renderComponent.node.zPosition = CGFloat(RenderingPosition.button.rawValue)
        renderComponent.node.posByScreen(x: position.x, y: position.y)
        self.addComponent(renderComponent)
        
        let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode(imageNamed: sprite))
        renderComponent.node.addChild(spriteComponent.spriteNode)
        spriteComponent.spriteNode.entity = self
        self.addComponent(spriteComponent)
        
        switch type {
        case .changeSprite:
            let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode(imageNamed: sprite))
            renderComponent.node.addChild(spriteComponent.spriteNode)
            spriteComponent.spriteNode.entity = self
            self.addComponent(spriteComponent)
            break
        case .changeAlpha:
            let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode(imageNamed: sprite))
            renderComponent.node.addChild(spriteComponent.spriteNode)
            spriteComponent.spriteNode.entity = self
            self.addComponent(spriteComponent)
            break
        case .changeScale:
            let spriteComponent = SpriteComponent(spriteNode: SKSpriteNode(imageNamed: sprite))
            renderComponent.node.addChild(spriteComponent.spriteNode)
            spriteComponent.spriteNode.entity = self
            self.addComponent(spriteComponent)
            break
        }

        let tapComponent = TapComponent()
        self.addComponent(tapComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
