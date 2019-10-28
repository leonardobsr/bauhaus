//
//  StartScene.swift
//  Bauhaus
//
//  Created by Rovane Moura on 21/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class StartScene : SKScene {
    
    var entityManager: EntityManager?
    var entities = [GKEntity]()
    
    var background : Background?
    
    var playButton : Button?
    var infoButton : Button?
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: 2732, height: 2048)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .aspectFit
        
        self.entityManager = EntityManager(scene: self)
        
        self.background = Background(position: .zero)
        
//        self.playButton = Button(position: .zero)
//        self.infoButton = Button(position: .zero)
        
        if  let entityManager = self.entityManager,
            let background = self.background {
//            let playButton = self.playButton,
//            let infoButton = self.infoButton {
            
            entityManager.add(background)
//            entityManager.add(playButton)
//            entityManager.add(infoButton)
                    
        }
    }

}
