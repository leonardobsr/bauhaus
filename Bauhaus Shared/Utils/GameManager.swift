//
//  GameManager.swift
//  Bauhaus
//
//  Created by Rovane Moura on 28/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class GameManager {
    
    static var shared = GameManager()
    
    weak var gameViewController : GameViewController?
    
    var currentScene : SKScene? {
        didSet {
            if let gameVC = self.gameViewController {
                let skView = gameVC.view as! SKView
                skView.presentScene(currentScene)
                
                skView.ignoresSiblingOrder = true
                skView.showsFPS = true
                skView.showsNodeCount = true
            }
        }
    }
    var stateMachine : GKStateMachine?
    
    private init() {
        let gameStates = [startScreenState(),
                          playerSelectionState(),
                          playState(),
                          pauseState(),
                          gameOverState()]
        
        self.stateMachine = GKStateMachine(states: gameStates)
        self.stateMachine!.enter(startScreenState.self)
    
    }
    
    func startGame(){
        self.currentScene = MenuScene.newGameScene()
        
        
        if let gameVC = self.gameViewController {
            let skView = gameVC.view as! SKView
            skView.presentScene(currentScene)
            
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            currentScene?.scaleMode = .aspectFill
        }
    }
    
    func nextScreen() {
        switch stateMachine!.currentState {
        case is startScreenState :
            
            stateMachine!.enter(playState.self)
            self.currentScene = GameScene.newGameScene()
        
        case is playerSelectionState : return
        case is playState : return
        case is pauseState : return
        case is gameOverState : return
        default : return
        }
    }
    
    func pauseGame() {
        stateMachine!.enter(pauseState.self)
    }
    
    func endGame() {
        stateMachine!.enter(gameOverState.self)
    }
    
}
