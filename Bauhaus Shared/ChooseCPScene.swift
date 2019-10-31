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
        
        // largura 1366 = 100%
        // altura 1024 = 100%
        // 0 -- 1 == 0% -- 100%
        self.backButton = Button(position: CGPoint(x: 0.10, y: 0.85), sprite: "backButton")
        
        self.descriptionLabel = Label(position: CGPoint(x: 0.49, y: 0.68), label: "Choose color and players")
        
        self.redPlayerButton = Button(position: CGPoint(x: 0.38, y: 0.54), sprite: "redPlayer")
        self.redPlayerLabel = Label(position: CGPoint(x: 0.42, y: 0.48), label: "P1")
        
        self.yellowPlayerButton = Button(position: CGPoint(x: 0.50, y: 0.54), sprite: "yellowPlayer")
        self.yellowPlayerLabel = Label(position: CGPoint(x: 0.51, y: 0.48), label: "P2")
        
        self.bluePlayerButton = Button(position: CGPoint(x: 0.58, y: 0.54), sprite: "bluePlayer")
        self.bluePlayerLabel = Label(position: CGPoint(x: 0.60, y: 0.48), label: "P3")
        
        self.playButton = Button(position: CGPoint(x: 0.50, y: 0.35), sprite: "playButton")

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
    }
}
