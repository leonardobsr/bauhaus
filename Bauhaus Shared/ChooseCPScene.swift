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
        
        self.backButton = Button(position: CGPoint(x: 0.05, y: 0.95), sprite: "backButton")
        
        self.chooseCPGroup = Group(position: CGPoint(x: -112.0, y: -112.0))
        self.redPlayerGroup = Group(position: CGPoint(x: -112.0, y: -112.0))
        self.yellowPlayerGroup = Group(position: CGPoint(x: -112.0, y: -112.0))
        self.bluePlayerGroup = Group(position: CGPoint(x: -112.0, y: -112.0))
        
        self.descriptionLabel = Label(position: CGPoint(x: -112.0, y: -112.0), label: "Choose color and players")
        
        self.redPlayerButton = Button(position: CGPoint(x: -112.0, y: -112.0), sprite: "redPlayer")
        self.redPlayerLabel = Label(position: CGPoint(x: -112.0, y: -112.0), label: "P1")
        
        self.redPlayerButton = Button(position: CGPoint(x: -112.0, y: -112.0), sprite: "yellowPlayer")
        self.redPlayerLabel = Label(position: CGPoint(x: -112.0, y: -112.0), label: "P2")
        
        self.redPlayerButton = Button(position: CGPoint(x: -112.0, y: -112.0), sprite: "bluePlayer")
        self.redPlayerLabel = Label(position: CGPoint(x: -112.0, y: -112.0), label: "P3")
        
        self.playButton = Button(position: CGPoint(x: -112.0, y: -112.0), sprite: "playButton")
        
        self.redPlayerGroup?.setChilds(childs: [self.redPlayerButton, self.redPlayerLabel])
        self.yellowPlayerGroup?.setChilds(childs: [self.yellowPlayerButton, self.yellowPlayerLabel])
        self.bluePlayerGroup?.setChilds(childs: [self.bluePlayerButton, self.bluePlayerLabel])
        self.chooseCPGroup?.setChilds(childs: [self.descriptionLabel, self.redPlayerGroup, self.yellowPlayerGroup, self.bluePlayerGroup, self.playButton])

        if  let entityManager = self.entityManager,
            let backButton = self.backButton,
            let chooseCPGroup = self.chooseCPGroup {
            entityManager.add(backButton)
            entityManager.add(chooseCPGroup)
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
    }
}
