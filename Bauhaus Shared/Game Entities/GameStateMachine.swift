//
//  GameStateMachine.swift
//  Bauhaus
//
//  Created by Rovane Moura on 07/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class startScreenState : GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is playerSelectionState.Type
    }
}

class playerSelectionState : GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is playState.Type
    }
}

class playState : GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass is pauseState.Type)
            || (stateClass is startScreenState.Type)
            || (stateClass is gameOverState.Type)
    }
}

class pauseState : GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass is playState.Type)
            || (stateClass is startScreenState.Type)
    }
}

class gameOverState : GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass is playState.Type)
            || (stateClass is startScreenState.Type)
    }
}
