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
    
    private var lastUpdateTime : TimeInterval = 0

    class func newChooseCPScene() -> ChooseCPScene {
        // Load 'ChooseCPScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "ChooseCPScene") as? ChooseCPScene else {
            print("Failed to load ChooseCPScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
//        self.lastUpdateTime = 0
//        
//        self.scene?.backgroundColor = UIColor.CustomGameColor.SpecialBlack
//        
//        self.entityManager = EntityManager(scene: self)
//        
//        self.backButton = Button(position: .zero)
//        
//        self.chooseCPGroup = Group(position: .zero)
//        
//        guard let groupNode = self.chooseCPGroup?.component(ofType: RenderComponent.self)?.node else {
//            return;
//        }
//        
//        self.redPlayerGroup = Group(position: .zero)
//        
//        guard let redPlayerGroupNode = self.redPlayerGroup?.component(ofType: RenderComponent.self)?.node else {
//            return;
//        }
//
//        self.yellowPlayerGroup = Group(position: .zero)
//        
//        guard let yellowPlayerGroupNode = self.yellowPlayerGroup?.component(ofType: RenderComponent.self)?.node else {
//            return;
//        }
//
//        self.bluePlayerGroup = Group(position: .zero)
//        
//        guard let bluePlayerGroupNode = self.bluePlayerGroup?.component(ofType: RenderComponent.self)?.node else {
//            return;
//        }
//        
//        self.descriptionLabel = Label(position: .zero)
//
//        if let descriptionLabelNode = self.descriptionLabel?.component(ofType: LabelComponent.self)?.labelNode, let node = self.descriptionLabel?.component(ofType: RenderComponent.self)?.node {
//            descriptionLabelNode.text = ("Choose color and players").uppercased()
//            groupNode.addChild(node)
//        }
//        
//        self.redPlayerButton = Button(position: .zero)
//
//        if let redPlayerNode = self.redPlayerButton?.component(ofType: RenderComponent.self)?.node {
//            self.redPlayerButton?.component(ofType: SpriteComponent.self)?.setTexture(imageNamed: "redPlayer")
//            redPlayerGroupNode.addChild(redPlayerNode)
//        }
//        
//        self.redPlayerLabel = Label(position: .zero)
//
//        if let redPlayerLabelNode = self.redPlayerLabel?.component(ofType: LabelComponent.self)?.labelNode, let node = self.redPlayerLabel?.component(ofType: RenderComponent.self)?.node {
//            redPlayerLabelNode.text = ("P1").uppercased()
//            redPlayerGroupNode.addChild(node)
//        }
//
//        self.yellowPlayerButton = Button(position: .zero)
//
//        if let yellowPlayerNode = self.yellowPlayerButton?.component(ofType: RenderComponent.self)?.node {
//            self.yellowPlayerButton?.component(ofType: SpriteComponent.self)?.setTexture(imageNamed: "yellowPlayer")
//            yellowPlayerGroupNode.addChild(yellowPlayerNode)
//        }
//        
//        self.yellowPlayerLabel = Label(position: .zero)
//
//        if let yellowPlayerLabelNode = self.yellowPlayerLabel?.component(ofType: LabelComponent.self)?.labelNode, let node = self.yellowPlayerLabel?.component(ofType: RenderComponent.self)?.node {
//            yellowPlayerLabelNode.text = ("P2").uppercased()
//            yellowPlayerGroupNode.addChild(node)
//        }
//
//        self.bluePlayerButton = Button(position: .zero)
//
//        if let bluePlayerNode = self.bluePlayerButton?.component(ofType: RenderComponent.self)?.node {
//            self.bluePlayerButton?.component(ofType: SpriteComponent.self)?.setTexture(imageNamed: "bluePlayer")
//            bluePlayerGroupNode.addChild(bluePlayerNode)
//        }
//        
//        self.bluePlayerLabel = Label(position: .zero)
//
//        if let bluePlayerLabelNode = self.bluePlayerLabel?.component(ofType: LabelComponent.self)?.labelNode, let node = self.bluePlayerLabel?.component(ofType: RenderComponent.self)?.node {
//            bluePlayerLabelNode.text = ("P3").uppercased()
//            bluePlayerGroupNode.addChild(node)
//        }
//        
//        groupNode.addChild(redPlayerGroupNode)
//        groupNode.addChild(yellowPlayerGroupNode)
//        groupNode.addChild(bluePlayerGroupNode)
//
//        if  let entityManager = self.entityManager,
//            let backButton = self.backButton,
//            let chooseCPGroup = self.chooseCPGroup {
//            entityManager.add(backButton)
//            entityManager.add(chooseCPGroup)
//        }
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
    }
}
