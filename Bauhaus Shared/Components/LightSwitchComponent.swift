//
//  LightSwitchComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 08/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class LightSwitchComponent : GKComponent {
 
    var node : SKSpriteNode
    var stateMachine : GKStateMachine
 
    init(node: SKSpriteNode) {
        self.node = node
        self.stateMachine = GKStateMachine(states: [OnState(), OffState()])
        super.init()
    }
 
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func turnOn() {
        if self.stateMachine.enter(OnState.self) {
            self.node.texture = SKTexture(imageNamed: "lineOn")
        }
    }
    
    func turnOff() {
        if self.stateMachine.enter(OffState.self) {
            self.node.texture = SKTexture(imageNamed: "lineOff")
        }
    }
    
}
