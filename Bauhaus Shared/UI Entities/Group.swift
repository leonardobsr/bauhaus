//
//  Group.swift
//  Bauhaus
//
//  Created by Leonardo Reis on 23/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Group : GKEntity {
    
    init(position: CGPoint) {
        super.init()
        
        let renderComponent = RenderComponent(node: SKNode())
        renderComponent.node.position = position
        self.addComponent(renderComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
