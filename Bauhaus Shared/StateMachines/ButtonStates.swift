//
//  PauseButtonStates.swift
//  Bauhaus
//
//  Created by Rovane Moura on 25/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class ActState : GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is RestState.Type
    }
}

class RestState : GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ActState.Type
    }
}
