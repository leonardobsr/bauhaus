//
//  GameScene.swift
//  Bauhaus Shared
//
//  Created by Leonardo Reis on 02/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entityManager: EntityManager?
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var touchedPiece : Piece?
    var availablePieces = [Piece]()
    
    var pauseButton : Button?
    var turnPassButton : Button?
    var timer : Timer?
    
    var board : Board?
    var originPosition: CGPoint?
    
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
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.lastUpdateTime = 0
        
        self.currentPlayer = UIColor(red: 245, green: 49, blue: 60)
        
        entityManager = EntityManager(scene: self)
        
        self.newBoard = Board(frame: self.frame)
        
        var dots = [[Dot]]()
        if let renderComponent = self.newBoard?.component(ofType: RenderComponent.self) {
//            renderComponent.node.position = CGPoint(x: -0.2 * self.frame.maxX, y: 0)
            renderComponent.node.posByScreen(x: 0.35, y: 0.5)
        }
        if let gridComponent = self.newBoard?.component(ofType: GridComponent.self) {
            let gridSize = CGSize(width: 10 * 56, height: 10 * 56)
            gridComponent.setGrid(width: 11, height: 11, size: gridSize)
            dots = gridComponent.dotGrid
        }

        if let board = self.newBoard {
            entityManager?.add(board)
        }

        dots.forEach { row in row.forEach { dot in entityManager?.add(dot) } }
                
//        let newPauseButton = Button(position: CGPoint(x: -610, y: 450), sprite: "pauseButton")
        let newPauseButton = Button(position: CGPoint(x: 0.05, y: 0.93), sprite: "pauseButton")
        newPauseButton.component(ofType: RenderComponent.self)?.node.setScale((self.size.height/self.size.width))
        newPauseButton.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        self.pauseButton = newPauseButton
        entityManager?.add(newPauseButton)
        
//        let newTurnPassButton = Button(position: CGPoint(x: 610, y: -450), sprite: "backButton")
        let newTurnPassButton = Button(position: CGPoint(x: 0.89, y: 0.07), sprite: "backButton")
        newTurnPassButton.component(ofType: RenderComponent.self)?.node.setScale((self.size.height/self.size.width))
        newTurnPassButton.component(ofType: RenderComponent.self)?.node.zRotation = 180 * .pi/180
        newTurnPassButton.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        self.turnPassButton = newTurnPassButton
        entityManager?.add(newTurnPassButton)
        
        loadRandomPieces()
        
        let newTimer = Timer()
        newTimer.component(ofType: RenderComponent.self)?.node.posByScreen(x: 1, y: 1.5)
        self.timer = newTimer
        entityManager?.add(newTimer)
    }
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
        self.physicsWorld.contactDelegate = self
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
        self.physicsWorld.contactDelegate = self
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
            let touchEndTime = CACurrentMediaTime()
            
            guard let pieceNode = piece.component(ofType: RenderComponent.self)?.node else {
                return
            }

            if touchEndTime - touchStartTime < 0.1 {
                pieceNode
                  .run(SKAction.rotate(byAngle: 90 * .pi/180, duration: 0.1))
            } else {
                  
                
                if (checkPiecePositionInBoard(piece: pieceNode)) {
                    piece
                        .component(ofType: PhysicsComponent.self)?
                        .node
                        .physicsBody?
                        .isDynamic = true
                } else {
                    if let originX = self.originPosition?.x,
                        let originY = self.originPosition?.y {
                        pieceNode.position = CGPoint(x: originX, y: originY)
                    }
                if findLinesHovered(by: piece) {
                    guard let grid = self.board?.component(ofType: GridComponent.self) else { return }
                    
                    entityManager?.remove(piece)
                    
                    connectDots(lastHoveredLines: grid.lastHoveredLines)
                    grid.lastHoveredLines = []
                    
                    findRectangles(lastConnectedDots: grid.lastConnectedDots)
                    grid.lastConnectedDots = []
                }
}
            }
            
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
    
    func turnPass() {
        timer?.component(ofType: RenderComponent.self)?.node.posByScreen(x: 1, y: 1.5)
        self.currentPlayer = nextPlayer()
    }
    
    func nextPlayer() -> UIColor? {
        if let player = self.currentPlayer {
            switch player {
            case UIColor(red: 245, green: 49, blue: 60) : return UIColor(red: 247, green: 242, blue: 74)
            case UIColor(red: 247, green: 242, blue: 74) : return UIColor(red: 25, green: 117, blue: 168)
            case UIColor(red: 25, green: 117, blue: 168) : return UIColor(red: 245, green: 49, blue: 60)
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
    
    func checkPiecePositionInBoard(piece: SKNode) -> Bool {
        if let nodeBoard = self.newBoard?.component(ofType: RenderComponent.self)?.node {
            let topLeft = CGPoint(x: piece.position.x - piece.calculateAccumulatedFrame().width / 2, y: piece.position.y + piece.calculateAccumulatedFrame().height / 2)
            let topRight = CGPoint(x: piece.position.x + piece.calculateAccumulatedFrame().width / 2, y: piece.position.y + piece.calculateAccumulatedFrame().height / 2)
            let bottomLeft = CGPoint(x: piece.position.x - piece.calculateAccumulatedFrame().width / 2, y: piece.position.y - piece.calculateAccumulatedFrame().height / 2)
            let bottomRight = CGPoint(x: piece.position.x + piece.calculateAccumulatedFrame().width / 2, y: piece.position.y - piece.calculateAccumulatedFrame().height / 2)

            return (nodeBoard.contains(topLeft) && nodeBoard.contains(topRight) && nodeBoard.contains(bottomLeft) && nodeBoard.contains(bottomRight))
        } else {
            return false
        }
    }
}

// Find Rectangles
extension GameScene {
    
    func findLinesHovered(by piece: Piece) -> Bool {
        guard
            let pieceNode = piece.component(ofType: SpriteComponent.self)?.spriteNode,
            let structurePoints = piece.component(ofType: PathComponent.self)?.structurePoints,
            let grid = self.board?.component(ofType: GridComponent.self)
        else { return false }
        
        var wasPlaced = false
        structurePoints.forEach { point in
            nodes(at: convert(point, from: pieceNode)).forEach { node in
                if let line = node.entity as? Line {
                    line.component(ofType: LightSwitchComponent.self)?.turnOn()
                    grid.lastHoveredLines.append(line)
                    wasPlaced = true
                }
            }
        }
        
        return wasPlaced
    }
    
    func connectDots(lastHoveredLines: [Line]) {
        lastHoveredLines.forEach { line in
            if let dots = line.component(ofType: IndexComponent.self)?.getConnectedDotsIndex() {
                self.board?.component(ofType: GridComponent.self)?.connect(firstDot: dots.firstDot, to: dots.secondDot)
            }
        }
    }
    
    func findRectangles(lastConnectedDots: Set<Dot>) {
        print("===================")
        lastConnectedDots.forEach { dot in print(findSquare(startingDot: dot, dot, .none, [:])) }
    }

    func findSquare(startingDot: Dot, _ currentDot: Dot, _ originDirection : Direction, _ moveTrack : [Axis : Direction]) -> Bool {
        
        if originDirection != .none && (currentDot == startingDot) { return true }
        
        var possibleMovements : [Direction] = [.up,.down,.left,.right]
        
        possibleMovements.removeAll { return ($0 == originDirection) || ($0 == moveTrack[.X]) || ($0 == moveTrack[.Y]) }
        
//        print(currentDot.id, originDirection, possibleMovements)
        
        if possibleMovements.isEmpty { return false }
        
        for i in 0 ..< possibleMovements.count {
            let move = possibleMovements[i]
            guard let dotConnections = currentDot.component(ofType: ConnectionComponent.self)?.connections
            else { return false }
            
//            if let nextDot = currentDot.connections[move] {
            if let nextDot = dotConnections[move] {
                var newMoveTrack = moveTrack
                let currentAxis = originDirection.axis()
                let nextAxis = move.axis()
                if nextAxis != currentAxis { newMoveTrack[currentAxis] = originDirection.opposite() }
                if findSquare(startingDot: startingDot, nextDot, move.opposite(), newMoveTrack) {
                    return true
                } else {
                    return false
                }
            }
        }
        
        return false
    }
    
    func drawRectangle(topRightCorner: CGPoint, downLeftCorner: CGPoint) {
        
    }
    
}
