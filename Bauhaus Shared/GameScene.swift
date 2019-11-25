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

    func setUpScene() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.lastUpdateTime = 0
        
        self.currentPlayer = UIColor(red: 245, green: 49, blue: 60)
        
        self.entityManager = EntityManager(scene: self)
        
        self.board = Board(frame: self.frame)
        
        var dots = [[Dot]]()
        if let renderComponent = self.board?.component(ofType: RenderComponent.self) {
//            renderComponent.node.position = CGPoint(x: -0.2 * self.frame.maxX, y: 0)
            renderComponent.spriteNode.posByScreen(x: 0.35, y: 0.5)
        }
        if let gridComponent = self.board?.component(ofType: GridComponent.self) {
            let gridSize = CGSize(width: 10 * 56, height: 10 * 56)
            gridComponent.setGrid(width: 11, height: 11, size: gridSize)
            dots = gridComponent.dotGrid
        }

        if let board = self.board {
            entityManager?.add(board)
        }

        dots.forEach { row in row.forEach { dot in entityManager?.add(dot) } }
                
//        let newPauseButton = Button(position: CGPoint(x: -610, y: 450), sprite: "pauseButton")
        let newPauseButton = Button(position: CGPoint(x: 0.05, y: 0.93), sprite: "pauseButton")
        newPauseButton.component(ofType: RenderComponent.self)?.spriteNode.setScale((self.size.height/self.size.width))
        newPauseButton.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        self.pauseButton = newPauseButton
        entityManager?.add(newPauseButton)
        
//        let newTurnPassButton = Button(position: CGPoint(x: 610, y: -450), sprite: "backButton")
        let newTurnPassButton = Button(position: CGPoint(x: 0.89, y: 0.07), sprite: "backButton")
        newTurnPassButton.component(ofType: RenderComponent.self)?.spriteNode.setScale((self.size.height/self.size.width))
        newTurnPassButton.component(ofType: RenderComponent.self)?.spriteNode.zRotation = 180 * .pi/180
        newTurnPassButton.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        self.turnPassButton = newTurnPassButton
        entityManager?.add(newTurnPassButton)
        
        loadRandomPieces()
        
        let newTimer = Timer()
        newTimer.component(ofType: RenderComponent.self)?.spriteNode.posByScreen(x: 0.95, y: 1)
        self.timer = newTimer
        entityManager?.add(newTimer)
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
        
        if let timerRenderNode = timer?.component(ofType: RenderComponent.self)?.spriteNode {
            if Int(timerRenderNode.position.y) == Int(self.frame.minY) {
                timerRenderNode.posByScreen(x: 0.95, y: 1)
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
            self.originPosition = piece.component(ofType: RenderComponent.self)?.spriteNode.position
            self.touchStartTime = CACurrentMediaTime()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let node = atPoint(t.location(in: self))
            if let entity = node.entity {
                switch entity {
                case is Button : tapOn(button: entity)
//                case is Line : tapOn(line: entity)
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

                if let node = piece.component(ofType: RenderComponent.self)?.spriteNode {
                    node.position = CGPoint(x: node.position.x + translation.x,
                                            y: node.position.y + translation.y)
                    
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let piece = touchedPiece {
            let touchEndTime = CACurrentMediaTime()
            
            guard let pieceNode = piece.component(ofType: RenderComponent.self)?.spriteNode else { return }

            if touchEndTime - touchStartTime < 0.1 {
                pieceNode.run(SKAction.rotate(byAngle: 90 * .pi/180, duration: 0.1))
            } else {
                if checkPiecePositionInBoard(piece: pieceNode) && findLinesHovered(by: piece) {
                    guard let grid = self.board?.component(ofType: GridComponent.self) else { return }
                        
                    entityManager?.remove(piece)
                        
                    connectDots(lastHoveredLines: grid.lastHoveredLines)
                    grid.lastHoveredLines = []
                        
                    findRectangles(lastConnectedDots: grid.lastConnectedDots)
                    grid.lastConnectedDots = []
                        
                    turnPass()
                    loadRandomPieces()
                } else {
                    if let originPosition = self.originPosition {
                        pieceNode.position = originPosition
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
        timer?.component(ofType: RenderComponent.self)?.spriteNode.posByScreen(x: 0.95, y: 1)
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
        piece.component(ofType: RenderComponent.self)?.spriteNode.posByScreen(x: 0.8, y: 0.2)
        entityManager?.add(piece)
                
        let piece2 = Piece(pathType: .Z, edgeSize: 2, pathSprite: possiblePieces.randomElement()!)
        piece2.component(ofType: RenderComponent.self)?.spriteNode.posByScreen(x: 0.8, y: 0.5)
        entityManager?.add(piece2)
                
        let piece3 = Piece(pathType: .Z, edgeSize: 2, pathSprite: possiblePieces.randomElement()!)
        piece3.component(ofType: RenderComponent.self)?.spriteNode.posByScreen(x: 0.8, y: 0.8)
        entityManager?.add(piece3)
        
        self.availablePieces.append(contentsOf: [piece, piece2, piece3])
    }
    
    func checkPiecePositionInBoard(piece: SKNode) -> Bool {
        if let nodeBoard = self.board?.component(ofType: RenderComponent.self)?.spriteNode {
            let topLeft = CGPoint(x: piece.position.x - piece.calculateAccumulatedFrame().width / 2, y: piece.position.y + piece.calculateAccumulatedFrame().height / 2)
            let topRight = CGPoint(x: piece.position.x + piece.calculateAccumulatedFrame().width / 2, y: piece.position.y + piece.calculateAccumulatedFrame().height / 2)
            let bottomLeft = CGPoint(x: piece.position.x - piece.calculateAccumulatedFrame().width / 2, y: piece.position.y - piece.calculateAccumulatedFrame().height / 2)
            let bottomRight = CGPoint(x: piece.position.x + piece.calculateAccumulatedFrame().width / 2, y: piece.position.y - piece.calculateAccumulatedFrame().height / 2)

            return (nodeBoard.contains(topLeft) && nodeBoard.contains(topRight) && nodeBoard.contains(bottomLeft) && nodeBoard.contains(bottomRight))
        } else {
            return false
        }
    }
    
    func snapToGrid(piece: SKNode) -> CGPoint {
        if let shapes = piece.entity?.component(ofType: PathComponent.self)?.structurePoints {
            print(shapes)
        }
        print(piece.position)
        let gridWidth = CGFloat(11.0)
        let gridHeight = CGFloat(11.0)
        
        let x = ((piece.position.x / gridWidth) * gridWidth).rounded(.down)
        let y = ((piece.position.y / gridHeight) * gridHeight).rounded(.down)
        
//        let x = ((piece.position.x.truncatingRemainder(dividingBy: gridWidth)) * gridWidth).rounded(.down)
//        let y = ((piece.position.y.truncatingRemainder(dividingBy: gridHeight)) * gridHeight).rounded(.down)

        print(x, y)
        return CGPoint(x: x, y: y)
    }
}

// Find Rectangles
extension GameScene {
    
    func findLinesHovered(by piece: Piece) -> Bool {
        guard
            let pieceNode = piece.component(ofType: RenderComponent.self)?.spriteNode,
            let structurePoints = piece.component(ofType: PathComponent.self)?.structurePoints,
            let grid = self.board?.component(ofType: GridComponent.self)
        else { return false }
        
        var isOverlapping = false
        var hoveredLines : [Line] = []

        structurePoints.forEach { point in
            let pointPieceToWorld = self.convert(point, from: pieceNode)
            nodes(at: pointPieceToWorld).forEach { node in
                if let line = node.entity as? Line {
                    if line.component(ofType: LightSwitchComponent.self)?.stateMachine.currentState is OnState {
                        isOverlapping = true
                    } else {
                        hoveredLines.append(line)
                    }
                }
            }
        }
        
        if !isOverlapping {
            hoveredLines.forEach { line in
                line.component(ofType: LightSwitchComponent.self)?.turnOn()
                grid.lastHoveredLines.append(line)
            }
            return true
        }
        
        return false
    }
    
    func connectDots(lastHoveredLines: [Line]) {
        lastHoveredLines.forEach { line in
            if let dots = line.component(ofType: IndexComponent.self)?.getConnectedDotsIndex() {
                self.board?.component(ofType: GridComponent.self)?.connect(firstDot: dots.firstDot, to: dots.secondDot)
            }
        }
    }
    
    func findRectangles(lastConnectedDots: Set<Dot>) {
        lastConnectedDots.forEach { dot in
            findRectangle(startingDot: dot,
                          currentDot: dot,
                          originDirection: .none,
                          moveTrack: [:],
                          visitedDots: [],
                          rectangleVertices: [dot.component(ofType: RenderComponent.self)!.spriteNode.position])
        }
    }

    func findRectangle(startingDot: Dot, currentDot: Dot, originDirection: Direction, moveTrack: [Axis : Direction], visitedDots: [Dot], rectangleVertices: [CGPoint]) {
        
        var possibleMovements : [Direction] = [.up,.down,.left,.right]
        
        possibleMovements.removeAll { move in (move == originDirection) || (move == moveTrack[.X]) || (move == moveTrack[.Y]) }
        
        if possibleMovements.isEmpty { return }
        
        possibleMovements = sortMovementPriority(moves: possibleMovements, currentAxis: originDirection.axis())
        
        possibleMovements.forEach { move in
            guard
                let dotConnections = currentDot.component(ofType: ConnectionComponent.self)?.connections,
                let dotRenderNode = currentDot.component(ofType: RenderComponent.self)?.spriteNode
            else { return }
                        
            var newMoveTrack = moveTrack
            var newVisitedDots = visitedDots ; newVisitedDots.append(currentDot)
            var newRectangleVertices = rectangleVertices
            
            if let nextDot = dotConnections[move] {
                let currentAxis = originDirection.axis()
                let nextAxis = move.axis()
                
                if originDirection != .none && nextAxis != currentAxis {
//                    signal(currentDot)
                    newMoveTrack[currentAxis] = originDirection.opposite()
                    newRectangleVertices.append(dotRenderNode.position)
                }
                
                if newVisitedDots.contains(nextDot) {
                    if nextDot == startingDot {
//                        signal(nextDot)
//                        print(newRectangleVertices)
                        drawRectangle(vertices: newRectangleVertices)
                    }
                } else {
                    findRectangle(startingDot: startingDot,
                                  currentDot: nextDot,
                                  originDirection: move.opposite(),
                                  moveTrack: newMoveTrack,
                                  visitedDots: newVisitedDots,
                                  rectangleVertices: newRectangleVertices)
                }
            }
        }
    }
    
    func sortMovementPriority(moves: [Direction], currentAxis: Axis) -> [Direction] {
        var sortedMoves : [Direction] = []

        let xMoves = moves.filter { $0 == .left || $0 == .right }
        let yMoves = moves.filter { $0 == .up || $0 == .down }
        
        if currentAxis == .Y {
            sortedMoves.append(contentsOf: xMoves)
            sortedMoves.append(contentsOf: yMoves)
        } else {
            sortedMoves.append(contentsOf: yMoves)
            sortedMoves.append(contentsOf: xMoves)
        }
        
        return sortedMoves
    }
    
    func drawRectangle(vertices: [CGPoint]) {
        guard
            var topLeft = vertices.first, var topRight = vertices.first,
            var bottomLeft = vertices.first, var bottomRight = vertices.first
        else { return }
                
        vertices.forEach { point in
            if point.x <= topLeft.x      &&  point.y >= topLeft.y        { topLeft = point }
            if point.y >= topRight.y     &&  point.x >= topRight.x       { topRight = point }
            if point.x <= bottomLeft.x   &&  point.y <= bottomLeft.y     { bottomLeft = point }
            if point.y <= bottomRight.y  &&  point.x >= bottomRight.x    { bottomRight = point }
        }
        
//        print("topLeft: \(topLeft), topRight: \(topRight), bottomLeft: \(bottomLeft), bottomRight: \(bottomRight)")
        
        if  topLeft.x == bottomLeft.x && topRight.x == bottomRight.x &&
            topLeft.y == topRight.y && bottomRight.y == bottomLeft.y {
            
            guard let gridComponent = self.board?.component(ofType: GridComponent.self) else { return }
            
            if gridComponent.boxCorners.contains(where: {
                $0.topLeft == topLeft || $0.topRight == topRight || $0.bottomLeft == bottomLeft || $0.bottomRight == bottomRight
            }) { return }
            
            if let color = currentPlayer {
                let size = CGSize(width: bottomRight.x - topLeft.x, height: topLeft.y - bottomRight.y)
                let position = CGPoint(x: topLeft.x, y: bottomRight.y)
                let box = Box(color: color, size: size, position: position)
                if let boxShapeNode = box.component(ofType: RectangleComponent.self)?.shapeNode {
                    gridComponent.gridNode.addChild(boxShapeNode)
                    gridComponent.boxCorners.append((topLeft,topRight,bottomLeft,bottomRight))
                    entityManager?.add(box)
                }
            }
        }
    }
    
    func signal(_ dot: Dot) {
        guard let node = dot.component(ofType: RenderComponent.self)?.spriteNode else { return }
        
        let shape = SKShapeNode(rectOf: CGSize(width: 10, height: 10))
        shape.name = "shape"
        shape.fillColor = currentPlayer!
        shape.zPosition = 200
        node.addChild(shape)
        
        let label = SKLabelNode(text: "\(node.position)")
        label.fontColor = .green
        label.fontSize = 10
        label.fontName = "Munro"
        label.position = CGPoint(x: 0, y: 0)
        label.zPosition = 200
        node.addChild(label)
    }
    
    func unsignal(_ dot: Dot) {
        dot.component(ofType: RenderComponent.self)?.spriteNode.childNode(withName: "shape")?.removeFromParent()
    }
    
}
