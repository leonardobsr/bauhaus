//
//  Label.swift
//  Bauhaus
//
//  Created by Leonardo Reis on 22/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Label : GKEntity {
    
    init(position: CGPoint, label: String) {
        super.init()
        
        let renderComponent = RenderComponent(spriteNode: SKSpriteNode())
        renderComponent.spriteNode.posByScreen(x: position.x, y: position.y)
        self.addComponent(renderComponent)
        
        let labelComponent = LabelComponent(labelNode: SKLabelNode())
        labelComponent.labelNode.text = label.uppercased()
        labelComponent.labelNode.fontName = "Munro"
        renderComponent.spriteNode.addChild(labelComponent.labelNode)
        self.addComponent(labelComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeText(newText: String) {
        self.component(ofType: LabelComponent.self)?.changeText(newText: newText)
    }
    
}
