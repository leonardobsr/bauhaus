//
//  MenuScene.swift
//  Bauhaus iOS
//
//  Created by Willian Antunes on 28/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    var entityManager: EntityManager?
    var entities = [GKEntity]()
    
    var playButton: Button?
    var infoButton: Button?
    
    class func newGameScene() -> MenuScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "MenuScene") as? MenuScene else {
            print("Failed to load MenuScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func didMove(to view: SKView) {
//        self.size = CGSize(width: 2732, height: 2048)
//        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        self.scaleMode = .aspectFill
        
        self.setUpScene()
    }
    
    func setUpScene() {
        
        entityManager = EntityManager(scene: self)
        
        guard let playButtonSprite = self.childNode(withName: "PlayButton") else {
            return
        }
        
        playButtonSprite.removeFromParent()
        
        playButton = Button(position: playButtonSprite.position, sprite: "MenuPlayButton")
        playButton?.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        entityManager?.add(playButton!)
        
        guard let infoButtonSprite = self.childNode(withName: "InfoButton") else {
            return
        }
        
        infoButtonSprite.removeFromParent()
        
        infoButton = Button(position:infoButtonSprite.position, sprite: "MenuInfoButton")
        infoButton?.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        entityManager?.add(infoButton!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let node = atPoint(t.location(in: self))
            
            if let button = node.entity as? Button {
                button.component(ofType: TapComponent.self)?.changeState()
                button.component(ofType: RenderComponent.self)?.node.alpha = 0.5
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let playButtonStateMachine = playButton?.component(ofType: TapComponent.self)?.stateMachine {
            if playButtonStateMachine.currentState is ActState {
                playButtonStateMachine.enter(RestState.self)
                GameManager.shared.nextScreen()
            }
        }
        
        if let infoButtonStateMachine = infoButton?.component(ofType: TapComponent.self)?.stateMachine {
            if infoButtonStateMachine.currentState is ActState {
                infoButtonStateMachine.enter(RestState.self)
            }
        }
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        <#code#>
//    }
    
    

}
