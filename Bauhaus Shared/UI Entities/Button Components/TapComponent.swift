//
//  TappableComponent.swift
//  Bauhaus iOS
//
//  Created by Rovane Moura on 21/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class TapComponent : GKComponent {
    
    var stateMachine : GKStateMachine
        
    override init() {
        self.stateMachine = GKStateMachine(states: [ActState(), RestState()])
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState() {
        switch stateMachine.currentState {
        case is ActState : stateMachine.enter(RestState.self)
        case is RestState : stateMachine.enter(ActState.self)
        default : return
        }
    }

    
}
