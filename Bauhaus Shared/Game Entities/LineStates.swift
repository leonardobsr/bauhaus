//
//  LineStateMachine.swift
//  Bauhaus
//
//  Created by Rovane Moura on 07/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class OnState : GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is OffState.Type
    }
    
}

class OffState : GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is OnState.Type
    }
    
}
