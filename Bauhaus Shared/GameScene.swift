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
    var availablePieces = [Piece]()
    
    var pauseButton : Button?
    
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
//        self.size = CGSize(width: 2732, height: 2048)
//        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
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
                
        self.pauseButton = Button(position: CGPoint(x: -610, y: 450), sprite: "pauseButton")
        pauseButton?.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        entityManager?.add(pauseButton!)
        
        loadRandomPieces()
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
        
        if let pauseButtonStateMachine = pauseButton?.component(ofType: TapComponent.self)?.stateMachine {
            if pauseButtonStateMachine.currentState is ActState {
                loadRandomPieces()
                pauseButtonStateMachine.enter(RestState.self)
            }
        }
        
    }
    
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    
    func tapOn(button entity: GKEntity) {
        if let button = entity as? Button {
            button
                .component(ofType: TapComponent.self)?
                .changeState()
        }
    }
    
    func tapOn(line entity: GKEntity) {
        if let line = entity as? Line {
            if let lightSwitch = line.component(ofType: LightSwitchComponent.self) {
                if lightSwitch.stateMachine.currentState is OnState {
                    lightSwitch.turnOff()
                } else {
                    lightSwitch.turnOn()
                }
            }
        }
    }
    
    func tapOn(piece entity: GKEntity) {
        if let piece = entity as? Piece {
            self.touchedPiece = piece
            touchedPiece?
                .component(ofType: RenderComponent.self)?
                .node
                .run(SKAction.scale(by: 1.2, duration: 0.1))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let node = atPoint(t.location(in: self))
            
            if let entity = node.entity {
                switch entity {
                case is Button : tapOn(button: entity)
                case is Line : tapOn(line: entity)
                case is Piece : tapOn(piece: entity)
                default : return
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let piece = touchedPiece {
            let touch = touches.first
            if  let currentPos = touch?.location(in: self),
                let previousPos = touch?.previousLocation(in: self) {
                
                let translation = CGPoint(x: currentPos.x - previousPos.x,
                                          y: currentPos.y - previousPos.y)

                if let node = piece.component(ofType: RenderComponent.self)?.node {
                    node.position = CGPoint(x: node.position.x + translation.x,
                                            y: node.position.y + translation.y)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let piece = touchedPiece {
            piece
                .component(ofType: RenderComponent.self)?
                .node
                .run(SKAction.scale(by: (1/1.2), duration: 0.1))
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
        
        self.availablePieces.forEach { entityManager?.remove($0) }
        
        var possiblePieces : [PathSprite] = [
            .I1, .I2, .L1, .L2, .U1, .U2, .T1, .T2, .Z1, .Z2
        ]
        
        let piece = Piece(pathType: .Z, edgeSize: 2, pathSprite: possiblePieces.randomElement()!)
        piece.component(ofType: RenderComponent.self)?.node.position = CGPoint(x: 420, y: -320)
        entityManager?.add(piece)
                
        let piece2 = Piece(pathType: .Z, edgeSize: 2, pathSprite: possiblePieces.randomElement()!)
        piece2.component(ofType: RenderComponent.self)?.node.position = CGPoint(x: 420, y: 0)
        entityManager?.add(piece2)
                
        let piece3 = Piece(pathType: .Z, edgeSize: 2, pathSprite: possiblePieces.randomElement()!)
        piece3.component(ofType: RenderComponent.self)?.node.position = CGPoint(x: 420, y: 320)
        entityManager?.add(piece3)
        
        self.availablePieces.append(contentsOf: [piece, piece2, piece3])
    }
    
}
