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
    
    var playersColors: [UIColor] = []
    
    var currentScene : SKScene? {
        didSet {
            guard let skView = self.gameViewController?.view as? SKView else { return }

            self.currentScene?.size = CGSize(width: skView.bounds.width, height: skView.bounds.height)
            
            skView.presentScene(self.currentScene)
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
        self.stateMachine?.enter(startScreenState.self)
    }
    
    func startGame() {
        self.currentScene = MenuScene.newGameScene()
        stateMachine?.enter(startScreenState.self)
        
        guard let skView = self.gameViewController?.view as? SKView else { return }
                
        self.currentScene?.size = skView.bounds.size
        
        skView.presentScene(self.currentScene)
    }
    
    func nextScreen() {
        switch stateMachine?.currentState {
        case is startScreenState :
            
            stateMachine?.enter(playerSelectionState.self)
            self.currentScene = ChooseCPScene.newChooseCPScene(size: SKViewSize!)
        
        case is playerSelectionState :
            
            stateMachine?.enter(playState.self)
            self.currentScene = GameScene()
            
        case is playState : return
        case is pauseState : return
        case is gameOverState : return
        default : return
        }
    }
    
    func pauseGame() {
//        stateMachine?.enter(pauseState.self)
        stateMachine?.enter(startScreenState.self)
        self.currentScene = MenuScene.newGameScene()
    }
    
    func endGame() {
        stateMachine?.enter(gameOverState.self)
    }
    
}
