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

    var touchedButton: Button?
    
    var blackMenuWidthProportional: Double?
    var blackMenuHeightProporcional: Double?
    
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
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.setUpScene()
    }
    
    func setUpScene() {
        
        let widthProportion = (self.frame.width * 100)/1366
        let heightProportion = (self.frame.height * 100)/1024
        
        entityManager = EntityManager(scene: self)
        
        guard let playButtonSprite = self.childNode(withName: "PlayButton") else {
            return
        }
        
        if let background = self.childNode(withName: "Background") {
            background.run(SKAction.resize(toWidth: self.frame.width, duration: 0))
            background.run(SKAction.resize(toHeight: self.frame.height, duration: 0))
        }
        
        playButtonSprite.removeFromParent()
        
//        playButton = Button(position: playButtonSprite.position, sprite: "MenuPlayButton")
        playButton = Button(position: CGPoint(x: 0.615, y: 0.1897), sprite: "PlayButtonWithName")
        
        playButton?.component(ofType: RenderComponent.self)?.node.xScale = widthProportion/100
        playButton?.component(ofType: RenderComponent.self)?.node.yScale = heightProportion/100
        
        playButton?.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        entityManager?.add(playButton!)
        
        guard let infoButtonSprite = self.childNode(withName: "InfoButton") else {
            return
        }
        
        infoButtonSprite.removeFromParent()
        
        infoButton = Button(position: CGPoint(x: 0.14298, y: 0.79), sprite: "MenuButtonWithName")
        
        infoButton?.component(ofType: RenderComponent.self)?.node.xScale = widthProportion/100
        infoButton?.component(ofType: RenderComponent.self)?.node.yScale = heightProportion/100
        
        infoButton?.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        entityManager?.add(infoButton!)
        
        
        
        let node = self.childNode(withName: "BlackMenuBar") as! SKSpriteNode
        blackMenuWidthProportional = Double(node.size.width) * Double(widthProportion)/100
        blackMenuHeightProporcional = Double(node.size.height) * Double(heightProportion)/100
    }

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
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let widthProportion = (self.frame.width * 100)/1366
        let heightProportion = (self.frame.height * 100)/1024
        
        if let playButtonStateMachine = playButton?.component(ofType: TapComponent.self)?.stateMachine {
            if playButtonStateMachine.currentState is ActState {
                playButtonStateMachine.enter(RestState.self)
                GameManager.shared.nextScreen()
            }
        }
        
        if let infoButtonStateMachine = infoButton?.component(ofType: TapComponent.self)?.stateMachine {
            if infoButtonStateMachine.currentState is ActState {
//                infoButtonStateMachine.enter(RestState.self)
                let node = self.childNode(withName: "BlackMenuBar") as! SKSpriteNode
                
                node.anchorPoint = CGPoint(x: 0, y: 1)
                node.size.width = CGFloat(Float(blackMenuWidthProportional!))
                node.size.height = CGFloat(Float(blackMenuHeightProporcional!))
                node.posByScreen(x: 0.081912152, y: 0.890525)
                
                let nodeDeveloper = node.childNode(withName: "DevelopersLogo-1") as! SKSpriteNode
                nodeDeveloper.xScale = widthProportion/100
                nodeDeveloper.yScale = heightProportion/100
                nodeDeveloper.anchorPoint = CGPoint(x: 0, y: 0)
                nodeDeveloper.position = CGPoint(x: node.frame.size.width*0.5277, y: -node.frame.size.height*0.7333)
                
                let nodeGameRules = node.childNode(withName: "gameRulesLogo-1") as! SKSpriteNode
                nodeGameRules.xScale = widthProportion/100
                nodeGameRules.yScale = heightProportion/100
                nodeGameRules.anchorPoint = CGPoint(x: 0, y: 0)
                nodeGameRules.position = CGPoint(x: node.frame.size.width*0.5277, y: -node.frame.size.height*0.4666)
                
                let nodeSoundOn = node.childNode(withName: "soundOnLogo-1") as! SKSpriteNode
                nodeSoundOn.xScale = widthProportion/100
                nodeSoundOn.yScale = heightProportion/100
                nodeSoundOn.anchorPoint = CGPoint(x: 0, y: 0)
                nodeSoundOn.position = CGPoint(x: node.frame.size.width*0.1111, y: -node.frame.size.height*0.4666)
  
                let nodeSoundOff = node.childNode(withName: "soundOffLogo-1") as! SKSpriteNode
                nodeSoundOff.xScale = widthProportion/100
                nodeSoundOff.yScale = heightProportion/100
                nodeSoundOff.anchorPoint = CGPoint(x: 0, y: 0)
                nodeSoundOff.position = CGPoint(x: node.frame.size.width*0.1111, y: -node.frame.size.height*0.7333+nodeSoundOff.size.height/2)
                
                node.zPosition = 10
            } else {
                let node = self.childNode(withName: "BlackMenuBar")
                node?.zPosition = 0
            }
        }
    }

}
