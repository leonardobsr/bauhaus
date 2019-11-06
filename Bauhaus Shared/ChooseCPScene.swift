//
//  ChooseCPScene.swift
//  Bauhaus
//
//  Created by Leonardo Reis on 22/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import SpriteKit
import GameplayKit

class ChooseCPScene : SKScene {
    
    var entityManager: EntityManager?
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var chooseCPGroup : Group?
    var redPlayerGroup : Group?
    var yellowPlayerGroup : Group?
    var bluePlayerGroup : Group?
    
    var backButton : Button?
    var redPlayerButton : Button?
    var yellowPlayerButton : Button?
    var bluePlayerButton : Button?
    var playButton : Button?
    
    var descriptionLabel : Label?
    var redPlayerLabel : Label?
    var yellowPlayerLabel : Label?
    var bluePlayerLabel : Label?
    
    var players: [UIColor] = []
    
    var touchedButton : Button?
    
    private var lastUpdateTime : TimeInterval = 0

    class func newChooseCPScene(size: CGSize) -> ChooseCPScene {
        // Load 'ChooseCPScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "ChooseCPScene") as? ChooseCPScene else {
            print("Failed to load ChooseCPScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.size = size
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        self.lastUpdateTime = 0

        self.scene?.backgroundColor = UIColor.black
        
        self.entityManager = EntityManager(scene: self)
        
        // largura 1366 = 100%
        // altura 1024 = 100%
        // 0 -- 1 == 0% -- 100%
        self.backButton = Button(position: CGPoint(x: 0.10, y: 0.85), sprite: "backButton")
        self.backButton?.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        
        self.descriptionLabel = Label(position: CGPoint(x: 0.5, y: 0.68), label: "Choose color and players")
        
        self.redPlayerButton = Button(position: CGPoint(x: 0.4, y: 0.55), sprite: "redPlayer")
        self.redPlayerButton?.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        self.redPlayerLabel = Label(position: CGPoint(x: 0.4, y: 0.45), label: "")
        
        self.yellowPlayerButton = Button(position: CGPoint(x: 0.5, y: 0.55), sprite: "yellowPlayer")
        self.yellowPlayerButton?.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        self.yellowPlayerLabel = Label(position: CGPoint(x: 0.5, y: 0.45), label: "")
        
        self.bluePlayerButton = Button(position: CGPoint(x: 0.6, y: 0.55), sprite: "bluePlayer")
        self.bluePlayerButton?.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        self.bluePlayerLabel = Label(position: CGPoint(x: 0.6, y: 0.45), label: "")
        
        self.playButton = Button(position: CGPoint(x: 0.50, y: 0.35), sprite: "playButton")
        self.playButton?.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)

        if  let entityManager = self.entityManager,
            let backButton = self.backButton,
            let descriptionLabel = self.descriptionLabel,
            let redPlayerButton = self.redPlayerButton,
            let redPlayerLabel = self.redPlayerLabel,
            let yellowPlayerButton = self.yellowPlayerButton,
            let yellowPlayerLabel = self.yellowPlayerLabel,
            let bluePlayerButton = self.bluePlayerButton,
            let bluePlayerLabel = self.bluePlayerLabel,
            let playButton = self.playButton {
            entityManager.add(backButton)
            entityManager.add(descriptionLabel)
            entityManager.add(redPlayerButton)
            entityManager.add(redPlayerLabel)
            entityManager.add(yellowPlayerButton)
            entityManager.add(yellowPlayerLabel)
            entityManager.add(bluePlayerButton)
            entityManager.add(bluePlayerLabel)
            entityManager.add(playButton)
        }
    }
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    #endif
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        
        if let backButtonSM = self.backButton?.component(ofType: TapComponent.self)?.stateMachine {
            if backButtonSM.currentState is ActState {
                GameManager.shared.startGame()
                backButtonSM.enter(RestState.self)
            }
        }
        
        if let playButtonSM = self.playButton?.component(ofType: TapComponent.self)?.stateMachine {
            if playButtonSM.currentState is ActState {
                if !players.isEmpty {
                    GameManager.shared.playersColors = players
                    GameManager.shared.nextScreen()
                }
                playButtonSM.enter(RestState.self)
            }
        }
        
        if let redPlayerButtonSM = self.redPlayerButton?.component(ofType: TapComponent.self)?.stateMachine {
            if redPlayerButtonSM.currentState is RestState {
                self.redPlayerButton?.component(ofType: RenderComponent.self)?.node.alpha = 0.5
                self.redPlayerLabel?.changeText(newText: "COM")
            }
        }
        
        if let yellowPlayerButtonSM = self.yellowPlayerButton?.component(ofType: TapComponent.self)?.stateMachine {
            if yellowPlayerButtonSM.currentState is RestState {
                self.yellowPlayerButton?.component(ofType: RenderComponent.self)?.node.alpha = 0.5
                self.yellowPlayerLabel?.changeText(newText: "COM")
            }
        }
        
        if let bluePlayerButtonSM = self.bluePlayerButton?.component(ofType: TapComponent.self)?.stateMachine {
            if bluePlayerButtonSM.currentState is RestState {
                self.bluePlayerButton?.component(ofType: RenderComponent.self)?.node.alpha = 0.5
                self.bluePlayerLabel?.changeText(newText: "COM")
            }
        }
        
        for (i, player) in players.enumerated() {
            switch player {
            case UIColor(red: 245, green: 49, blue: 60):
                self.redPlayerLabel?.changeText(newText: "P" + (i+1).description)
            case UIColor(red: 25, green: 117, blue: 168):
                self.bluePlayerLabel?.changeText(newText: "P" + (i+1).description)
            case UIColor(red: 247, green: 242, blue: 74):
                self.yellowPlayerLabel?.changeText(newText: "P" + (i+1).description)
            default:
                break
            }
        }
        
        if players.isEmpty {
            self.redPlayerLabel?.changeText(newText: "")
            self.bluePlayerLabel?.changeText(newText: "")
            self.yellowPlayerLabel?.changeText(newText: "")
        }
    }
}

extension ChooseCPScene {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let node = atPoint(t.location(in: self))
            
            if let button = node.entity as? Button {
                self.touchedButton = button
                button.component(ofType: RenderComponent.self)?.node.alpha = 0.5
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let button = self.touchedButton {
            button.component(ofType: TapComponent.self)?.changeState()
            button.component(ofType: RenderComponent.self)?.node.alpha = 1
        }
        
        if self.touchedButton == self.redPlayerButton {
            if players.contains(where: { $0 == UIColor(red: 245, green: 49, blue: 60) }) {
                players.removeAll(where: { $0 == UIColor(red: 245, green: 49, blue: 60) })
            } else {
                players.append(UIColor(red: 245, green: 49, blue: 60))
            }
        }
        
        if self.touchedButton == self.bluePlayerButton {
            if players.contains(where: { $0 == UIColor(red: 25, green: 117, blue: 168) }) {
                players.removeAll(where: { $0 == UIColor(red: 25, green: 117, blue: 168) })
            } else {
                players.append(UIColor(red: 25, green: 117, blue: 168))
            }
        }
        
        if self.touchedButton == self.yellowPlayerButton {
            if players.contains(where: { $0 == UIColor(red: 247, green: 242, blue: 74) }) {
                players.removeAll(where: { $0 == UIColor(red: 247, green: 242, blue: 74) })
            } else {
                players.append(UIColor(red: 247, green: 242, blue: 74))
            }
        }
        
    }
    
}
