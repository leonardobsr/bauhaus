//
//  LightSwitchComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 08/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class LightSwitchComponent : GKComponent {
 
    var node : SKNode
 
    init(node: SKNode) {
        self.node = node
        
        super.init()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func turnOn() {
        self.node.isHidden = false
    }
    
    func turnOff() {
        self.node.isHidden = true
    }
    
}
