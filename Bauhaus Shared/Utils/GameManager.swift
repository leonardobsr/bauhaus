//
//  GameManager.swift
//  Bauhaus
//
//  Created by Rovane Moura on 28/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class GameManager {
    
    weak var gameViewController : GameViewController?
    
    var currentScene : SKScene {
        didSet {
            if let gameVC = self.gameViewController {
                let skView = gameVC.view as! SKView
                skView.presentScene(currentScene)
                
                skView.ignoresSiblingOrder = true
                skView.showsFPS = true
                skView.showsNodeCount = true
                
//                currentScene.scaleMode = .aspectFill
            }
        }
    }
    var stateMachine : GKStateMachine
    
    init(gameViewController: GameViewController) {
        
        self.gameViewController = gameViewController
        
        let gameStates = [startScreenState(),
                          playerSelectionState(),
                          playState(),
                          pauseState(),
                          gameOverState()]
        
        self.stateMachine = GKStateMachine(states: gameStates)
        self.stateMachine.enter(startScreenState.self)
        
        self.currentScene = StartScene()
        
        if let gameVC = self.gameViewController {
            let skView = gameVC.view as! SKView
            skView.presentScene(currentScene)
            
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            currentScene.scaleMode = .aspectFill
        }

    }
    
    func nextScreen() {
        switch stateMachine.currentState {
        case is startScreenState :
            
            stateMachine.enter(playState.self)
            self.currentScene = GameScene.newGameScene()
        
        case is playerSelectionState : return
        case is playState : return
        case is pauseState : return
        case is gameOverState : return
        default : return
        }
    }
    
    func pauseGame() {
        stateMachine.enter(pauseState.self)
    }
    
    func endGame() {
        stateMachine.enter(gameOverState.self)
    }
    
}

protocol GameManagerDelegate : class {
    
}
