//
//  VisualResponseComponent.swift
//  Bauhaus iOS
//
//  Created by Rovane Moura on 21/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class VisualResponseComponent : GKComponent {
    
    var node : SKNode
    
    init(node: SKNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
