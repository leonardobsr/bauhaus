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
    var turnPassButton : Button?
    var timer : Timer?
    
    var currentPlayer : UIColor? {
        didSet {
            if let player = self.currentPlayer {
                self.backgroundColor = player
            }
        }
    }
    
    private var touchStartTime : TimeInterval = 0
    
    private var lastUpdateTime : TimeInterval = 0

//    class func newGameScene() -> GameScene {
//        // Load 'GameScene.sks' as an SKScene.
//        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
//            print("Failed to load GameScene.sks")
//            abort()
//        }
//
//        // Set the scale mode to scale to fit the window
//        scene.scaleMode = .aspectFill
//
//        return scene
//    }

    func setUpScene() {
//        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        
//        self.lastUpdateTime = 0
//        
//        self.currentPlayer = .red
//        
//        entityManager = EntityManager(scene: self)
//        
//        let newBoard = Board(frame: self.frame)
//        var dots = [[Dot]]()
//        if let renderComponent = newBoard.component(ofType: RenderComponent.self) {
////            renderComponent.node.position = CGPoint(x: -0.2 * self.frame.maxX, y: 0)
//            renderComponent.node.posByScreen(x: 0.35, y: 0.5)
//        }
//        if let gridComponent = newBoard.component(ofType: GridComponent.self) {
//            let gridSize = CGSize(width: 10 * 56, height: 10 * 56)
//            gridComponent.setGrid(width: 11, height: 11, size: gridSize)
//            dots = gridComponent.dotGrid
//        }
//        entityManager?.add(newBoard)
//        dots.forEach { row in row.forEach { dot in entityManager?.add(dot) } }
//                
////        let newPauseButton = Button(position: CGPoint(x: -610, y: 450), sprite: "pauseButton")
//        let newPauseButton = Button(position: CGPoint(x: 0.05, y: 0.93), sprite: "pauseButton")
//        newPauseButton.component(ofType: RenderComponent.self)?.node.setScale((self.size.height/self.size.width))
//        newPauseButton.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
//        self.pauseButton = newPauseButton
//        entityManager?.add(newPauseButton)
//        
////        let newTurnPassButton = Button(position: CGPoint(x: 610, y: -450), sprite: "backButton")
//        let newTurnPassButton = Button(position: CGPoint(x: 0.89, y: 0.07), sprite: "backButton")
//        newTurnPassButton.component(ofType: RenderComponent.self)?.node.setScale((self.size.height/self.size.width))
//        newTurnPassButton.component(ofType: RenderComponent.self)?.node.zRotation = 180 * .pi/180
//        newTurnPassButton.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
//        self.turnPassButton = newTurnPassButton
//        entityManager?.add(newTurnPassButton)
//        
//        loadRandomPieces()
//        
//        let newTimer = Timer()
//        newTimer.component(ofType: RenderComponent.self)?.node.posByScreen(x: 1, y: 1.5)
//        self.timer = newTimer
//        entityManager?.add(newTimer)
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
        for entity in self.entityManager!.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        
        if let pauseButtonSM = self.pauseButton?.component(ofType: TapComponent.self)?.stateMachine {
            if pauseButtonSM.currentState is ActState {
                GameManager.shared.pauseGame()
                pauseButtonSM.enter(RestState.self)
            }
        }
        
        if let turnPassButtonSM = self.turnPassButton?.component(ofType: TapComponent.self)?.stateMachine {
            if turnPassButtonSM.currentState is ActState {
                turnPass()
                loadRandomPieces()
                turnPassButtonSM.enter(RestState.self)
            }
        }
        
        if let timerRenderNode = timer?.component(ofType: RenderComponent.self)?.node,
            let timerShapeNode = timer?.component(ofType: RectangleComponent.self)?.shapeNode {
            if timerRenderNode.position.y - timerShapeNode.frame.height/2 == self.frame.minY {
                timerRenderNode.posByScreen(x: 1, y: 1.5)
                loadRandomPieces()
                self.currentPlayer = nextPlayer()
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
            self.touchStartTime = CACurrentMediaTime()
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
            
            let touchEndTime = CACurrentMediaTime()

            if touchEndTime - touchStartTime < 0.1 {
                piece
                    .component(ofType: RenderComponent.self)?
                    .node
                    .run(SKAction.rotate(byAngle: 90 * .pi/180, duration: 0.1))
            }
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
    
    func turnPass() {
        timer?.component(ofType: RenderComponent.self)?.node.posByScreen(x: 1, y: 1.5)
        self.currentPlayer = nextPlayer()
    }
    
    func nextPlayer() -> UIColor? {
        if let player = self.currentPlayer {
            switch player {
            case .red : return .yellow
            case .yellow : return .blue
            case .blue : return .red
            default : return .red
            }
        }
        return nil
    }
    
    func loadRandomPieces() {
        self.touchedPiece = nil
        self.availablePieces.forEach { entityManager?.remove($0) }
        
        let possiblePieces : [PathSprite] = [.I1, .I2, .L1, .L2, .U1, .U2, .T1, .T2, .Z1, .Z2]
        
        let piece = Piece(pathType: .Z, edgeSize: 2, pathSprite: possiblePieces.randomElement()!)
        piece.component(ofType: RenderComponent.self)?.node.posByScreen(x: 0.8, y: 0.2)
        entityManager?.add(piece)
                
        let piece2 = Piece(pathType: .Z, edgeSize: 2, pathSprite: possiblePieces.randomElement()!)
        piece2.component(ofType: RenderComponent.self)?.node.posByScreen(x: 0.8, y: 0.5)
        entityManager?.add(piece2)
                
        let piece3 = Piece(pathType: .Z, edgeSize: 2, pathSprite: possiblePieces.randomElement()!)
        piece3.component(ofType: RenderComponent.self)?.node.posByScreen(x: 0.8, y: 0.8)
        entityManager?.add(piece3)
        
        self.availablePieces.append(contentsOf: [piece, piece2, piece3])
    }
    
}
