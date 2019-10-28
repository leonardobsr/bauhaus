//
//  GameScene.swift
//  Bauhaus Shared
//
//  Created by Leonardo Reis on 02/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entityManager: EntityManager?
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var touchedPiece : Piece?
    
    private var lastUpdateTime : TimeInterval = 0

    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }

    func setUpScene() {
        self.lastUpdateTime = 0
        
        self.backgroundColor = .red
        
        entityManager = EntityManager(scene: self)
        
        let newBoard = Board()
        var dots = [[Dot]]()
        if let renderComponent = newBoard.component(ofType: RenderComponent.self) {
            renderComponent.node.position = CGPoint(x: -150, y: 0)
        }
        if let gridComponent = newBoard.component(ofType: GridComponent.self) {
            gridComponent.setGrid(width: 12, height: 12)
            dots = gridComponent.dotGrid
        }
        entityManager?.add(newBoard)
        
        dots.forEach { row in row.forEach { dot in entityManager?.add(dot) } }
                
        let pauseButton = Button(position: CGPoint(x: -610, y: 450), sprite: "pauseButton")
        pauseButton.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        entityManager?.add(pauseButton)
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

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let node = atPoint(t.location(in: self))
            
            if let light = node.entity?.component(ofType: LightSwitchComponent.self) {
                if light.stateMachine.currentState is OnState {
                    light.turnOff()
                } else {
                    light.turnOn()
                }
            }
            
            if let piece = node.entity as? Piece {
                self.touchedPiece = piece
                touchedPiece?
                    .component(ofType: RenderComponent.self)?
                    .node
                    .run(SKAction.scale(by: 1.2, duration: 0.1))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if  let currentPos = touch?.location(in: self),
            let previousPos = touch?.previousLocation(in: self) {
            
            let translation = CGPoint(x: currentPos.x - previousPos.x,
                                      y: currentPos.y - previousPos.y)

            if let node = touchedPiece?.component(ofType: RenderComponent.self)?.node {
                node.position = CGPoint(x: node.position.x + translation.x,
                                        y: node.position.y + translation.y)
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let piece = touchedPiece {
            piece.component(ofType: RenderComponent.self)?.node.run(SKAction.scale(by: (1/1.2), duration: 0.1))
            touchedPiece = nil
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {}
    
    override func mouseDragged(with event: NSEvent) {}
    
    override func mouseUp(with event: NSEvent) {}

}
#endif

extension GameScene {
    
    func loadRandomPieces() {
        let piece = Piece(pathType: .Z, edgeSize: 2, pathSprite: .U1)
                
        piece.component(ofType: RenderComponent.self)?.node.position = CGPoint(x: 420, y: -320)
        entityManager?.add(piece)
                
        let piece2 = Piece(pathType: .Z, edgeSize: 2, pathSprite: .L1)
        piece2.component(ofType: RenderComponent.self)?.node.position = CGPoint(x: 420, y: 0)
        entityManager?.add(piece2)
                
        let piece3 = Piece(pathType: .Z, edgeSize: 2, pathSprite: .T1)
        piece3.component(ofType: RenderComponent.self)?.node.position = CGPoint(x: 420, y: 320)
        entityManager?.add(piece3)
    }
    
}
