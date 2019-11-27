//
//  GameScene.swift
//  Bauhaus Shared
//
//  Created by Leonardo Reis on 02/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import SpriteKit
import GameplayKit

class Player {
    var color : UIColor
    var score : Int
    var boxCount : Int
    
    init(color: UIColor, score: Int, boxCount: Int) {
        self.color = color
        self.score = score
        self.boxCount = boxCount
    }
}

class GameScene: SKScene {
    
    var entityManager: EntityManager?

    var availablePieces : [Piece] = []
    var touchedPiece : Piece?
    var originPosition: CGPoint?
    
    var pauseButton : Button?
    var turnPassButton : Button?
    var timer : Timer?
    
    var board : Board?
    var dots = [[Dot]]()
    var playerBorder : SKShapeNode?
    
    var currentPlayer : UIColor? {
        didSet {
            if let player = self.currentPlayer {
                self.playerBorder?.fillColor = player
                self.timer?.component(ofType: RectangleComponent.self)?.shapeNode.fillColor = player
            }
        }
    }
    
    var playerBoard : [Player] = []
        
    private var touchStartTime : TimeInterval = 0
    
    private var lastUpdateTime : TimeInterval = 0

    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    func setUpScene() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .white
        
        self.lastUpdateTime = 0
        
        self.entityManager = EntityManager(scene: self)
        
        self.board = Board(frame: self.frame)
        
        var boardSize : CGSize = .zero
        var boardPosition : CGPoint = .zero
        
        if let node = self.board?.component(ofType: RenderComponent.self)?.spriteNode {
            node.posByScreen(x: 0.38, y: 0.5)
            boardSize = node.size
            boardPosition = node.position
        }
                
        if let gridComponent = self.board?.component(ofType: GridComponent.self) {
            let boardEdge = Int(boardSize.width * 0.85)

            let dotAmount = boardEdge/56
            let n1 = dotAmount * 56
            let n2 = 56 * (dotAmount + 1)

            var gridEdge = 0

            if abs(boardEdge - n1) < abs(boardEdge - n2) { gridEdge = n1 }
            else { gridEdge = n2 }

            let gridSize = CGSize(width: Double(gridEdge), height: Double(gridEdge))

            gridComponent.setGrid(width: Int(gridEdge/56) + 1, height: Int(gridEdge/56) + 1, size: gridSize)
            dots = gridComponent.dotGrid
        }

        if let board = self.board { entityManager?.add(board) }
        dots.forEach { row in row.forEach { dot in entityManager?.add(dot) } }
        
        self.playerBorder = SKShapeNode(rectOf: CGSize(width: boardSize.width * 1.1, height: boardSize.height * 1.1))
        self.playerBorder?.position = boardPosition
        self.playerBorder?.strokeColor = .clear
        self.addChild(playerBorder!)

        let newPauseButton = Button(position: CGPoint(x: 0.05, y: 0.93), sprite: "pauseButton")
        newPauseButton.component(ofType: RenderComponent.self)?.spriteNode.setScale((self.size.height/self.size.width) * 2)
        newPauseButton.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        self.pauseButton = newPauseButton
        entityManager?.add(newPauseButton)
        
        let newTurnPassButton = Button(position: CGPoint(x: 0.89, y: 0.07), sprite: "nextPlayerButton")
        newTurnPassButton.component(ofType: RenderComponent.self)?.spriteNode.setScale((self.size.height/self.size.width) * 2)
        newTurnPassButton.component(ofType: TapComponent.self)?.stateMachine.enter(RestState.self)
        self.turnPassButton = newTurnPassButton
        entityManager?.add(newTurnPassButton)
        
        loadRandomPieces()
        
        let newTimer = Timer(position: CGPoint(x: 0.95, y: 1))
        self.timer = newTimer
        entityManager?.add(newTimer)
        
        GameManager.shared.players.forEach { color in self.playerBoard.append(Player(color: color, score: 0, boxCount: 0)) }
        self.playerBoard.shuffle()
        
        let playerExMachina = Player(color: UIColor.white, score: 0, boxCount: 0)
        self.playerBoard.append(playerExMachina)
        
        nextPlayer()
        
        timer?.start()
    }
    
    func nextPlayer() {
        let nextPlayer = playerBoard.removeFirst()
        
        self.currentPlayer = nextPlayer.color
        self.playerBoard.append(nextPlayer)
        
        self.timer?.reset()
        
        loadRandomPieces()
    }
    
    func loadRandomPieces() {
        self.touchedPiece = nil
        self.availablePieces.forEach { entityManager?.remove($0) }
        
        let possiblePieces : [PathSprite] = [.I1, .I2, .L1, .L2, .U1, .U2, .T1, .T2, .Z1, .Z2]
        
        let piece = Piece(pathSprite: possiblePieces.randomElement()!)
        piece.component(ofType: RenderComponent.self)?.spriteNode.posByScreen(x: 0.8, y: 0.2)
        entityManager?.add(piece)
                
        let piece2 = Piece(pathSprite: possiblePieces.randomElement()!)
        piece2.component(ofType: RenderComponent.self)?.spriteNode.posByScreen(x: 0.8, y: 0.5)
        entityManager?.add(piece2)
                
        let piece3 = Piece(pathSprite: possiblePieces.randomElement()!)
        piece3.component(ofType: RenderComponent.self)?.spriteNode.posByScreen(x: 0.8, y: 0.8)
        entityManager?.add(piece3)
        
        self.availablePieces.append(contentsOf: [piece, piece2, piece3])
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) { self.lastUpdateTime = currentTime }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entityManager!.entities { entity.update(deltaTime: dt) }
        
        self.lastUpdateTime = currentTime
        
        if let pauseButtonSM = self.pauseButton?.component(ofType: TapComponent.self)?.stateMachine {
            if pauseButtonSM.currentState is ActState {
                pauseButtonSM.enter(RestState.self)
                GameManager.shared.pauseGame()
            }
        }
        
        if let turnPassButtonSM = self.turnPassButton?.component(ofType: TapComponent.self)?.stateMachine {
            if turnPassButtonSM.currentState is ActState {
                turnPassButtonSM.enter(RestState.self)
                nextPlayer()
            }
        }
        
        if let timerRenderNode = timer?.component(ofType: RectangleComponent.self)?.shapeNode {
            if Int(timerRenderNode.position.y) == Int(self.frame.minY) {
               nextPlayer()
            }
        }
        
        self.playerBoard.forEach { player in
            if player.boxCount >= 3 {
                print("Game Over! \(player.color) wins!")
                self.currentPlayer = player.color
                self.backgroundColor = player.color
                timer?.reset()
                timer?.stop()
            }
        }
        
    }
    
}

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
            piece
                .component(ofType: RenderComponent.self)?
                .spriteNode
                .setScale(2)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let t = touches.first,
            let entity = atPoint(t.location(in: self)).entity
        else { return }
        
        switch entity {
        case is Button : tapOn(button: entity)
        case is Piece : tapOn(piece: entity)
//        case is Line : tapOn(line: entity)
        default : return
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
                pieceNode.run(SKAction.rotate(byAngle: 90 * .pi/180, duration: 0.1), completion: {
                    pieceNode.setScale((SKViewSize!.height/SKViewSize!.width) * 2)
                })
            } else {
                snapToGrid(piece: pieceNode)
                if checkPiecePositionInBoard(piece: pieceNode) && findLinesHovered(by: piece) {
                    guard let grid = self.board?.component(ofType: GridComponent.self) else { return }

                    entityManager?.remove(piece)

                    connectDots(lastHoveredLines: grid.lastHoveredLines)
                    grid.lastHoveredLines = []

                    findRectangles(lastConnectedDots: grid.lastConnectedDots)
                    grid.lastConnectedDots = []

                    nextPlayer()
                } else {
                    if let originPosition = self.originPosition {
                        pieceNode.position = originPosition
                        pieceNode.setScale((SKViewSize!.height/SKViewSize!.width) * 2)
                    }
                }
            }
            
            touchedPiece = nil
        }
    }
        
}

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {}

    override func mouseDragged(with event: NSEvent) {}
    
    override func mouseUp(with event: NSEvent) {}

}
#endif

// Piece positioning handling
extension GameScene {
    
    func checkPiecePositionInBoard(piece: SKNode) -> Bool {
        if let nodeBoard = self.board?.component(ofType: RenderComponent.self)?.spriteNode {
            let topLeft = CGPoint(x: piece.position.x - piece.calculateAccumulatedFrame().width / 2,
                                  y: piece.position.y + piece.calculateAccumulatedFrame().height / 2)
            
            let topRight = CGPoint(x: piece.position.x + piece.calculateAccumulatedFrame().width / 2,
                                   y: piece.position.y + piece.calculateAccumulatedFrame().height / 2)
            
            let bottomLeft = CGPoint(x: piece.position.x - piece.calculateAccumulatedFrame().width / 2,
                                     y: piece.position.y - piece.calculateAccumulatedFrame().height / 2)
            
            let bottomRight = CGPoint(x: piece.position.x + piece.calculateAccumulatedFrame().width / 2,
                                      y: piece.position.y - piece.calculateAccumulatedFrame().height / 2)

            return (nodeBoard.contains(topLeft) && nodeBoard.contains(topRight) &&
                    nodeBoard.contains(bottomLeft) && nodeBoard.contains(bottomRight))
        }
        return false
    }
    
    func snapToGrid(piece: SKNode) {
        let dotMatrix = self.dots
        let pieceCAF = piece.calculateAccumulatedFrame()
        let pieceTopLeft = CGPoint(x: piece.position.x - pieceCAF.width / 2,
                                   y: piece.position.y + pieceCAF.height / 2)

        var minDistance = CGFloat(9999)
        var nearestDot = SKSpriteNode()
        var nearestDotScenePosition = CGPoint()

        dotMatrix.forEach { dotRow in
            dotRow.forEach { dot in
                guard
                    let dotNode = dot.component(ofType: RenderComponent.self)?.spriteNode,
                    let dotScenePosition = dotNode.parent?.convert(dotNode.position, to: self)
                else { return }
                let delta = distance(pieceTopLeft, dotScenePosition)
                if delta < minDistance {
                    minDistance = delta
                    nearestDot = dotNode
                    nearestDotScenePosition = dotScenePosition
                }
            }
        }

        let nearestDotCAF = nearestDot.calculateAccumulatedFrame()

        piece.position = CGPoint(x: nearestDotScenePosition.x - ((nearestDotCAF.width) - (pieceCAF.width / 2)),
                                 y: nearestDotScenePosition.y + ((nearestDotCAF.height) - (pieceCAF.height / 2)))
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
}

// Rectangle recognition handling
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
            findRectangles(startingDot: dot,
                           currentDot: dot,
                           originDirection: .none,
                           moveTrack: [:],
                           visitedDots: [],
                           rectangleVertices: [dot.component(ofType: RenderComponent.self)!.spriteNode.position])
        }
    }

    func findRectangles(startingDot: Dot, currentDot: Dot, originDirection: Direction, moveTrack: [Axis : Direction], visitedDots: [Dot], rectangleVertices: [CGPoint]) {
        
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
                    newMoveTrack[currentAxis] = originDirection.opposite()
                    newRectangleVertices.append(dotRenderNode.position)
                }
                
                if newVisitedDots.contains(nextDot) {
                    if nextDot == startingDot { drawRectangle(vertices: newRectangleVertices) }
                } else {
                    findRectangles(startingDot: startingDot,
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
                    
                    let board = playerBoard.last
                    board?.boxCount += 1
                }
            }
        }
    }
    
    func signal(piece: Piece, position: CGPoint) {
        guard let node = piece.component(ofType: RenderComponent.self)?.spriteNode else { return }
        
        let shape = SKShapeNode(rectOf: CGSize(width: 10, height: 10))
        shape.name = "shape"
        shape.fillColor = currentPlayer!
        shape.zPosition = 200
        shape.position = position
        node.addChild(shape)
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
