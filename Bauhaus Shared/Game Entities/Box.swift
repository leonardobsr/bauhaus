//
//  Box.swift
//  Bauhaus
//
//  Created by Rovane Moura on 07/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Box : GKEntity {
    
    override init() {
        // Visual Components
        
        let renderComponent = RenderComponent()
        self.addComponent(renderComponent)
        
        // Z Position = 2
        
        // shape node component
        // color
        // size
        // position
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
