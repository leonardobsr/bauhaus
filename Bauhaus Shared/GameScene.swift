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
        
        var dots = [[Dot]]()
        let newBoard = Board()
        if let boardComponent = newBoard.component(ofType: GridComponent.self) {
            boardComponent.setGrid(width: 10, height: 10)
            dots = boardComponent.dotGrid
        }
        
        if let renderComponent = newBoard.component(ofType: RenderComponent.self) {
            renderComponent.node.position = CGPoint(x: CGFloat(0), y: CGFloat(0))
        }
        
        entityManager?.add(newBoard)
        
        for i in 0 ..< 10 {
            for j in 0 ..< 10 {
                entityManager?.add(dots[i][j])
            }
        }
        
        // Rovane
        let piece = Piece(pathType: .Z, edgeSize: 2)
        printMatrix(piece.component(ofType: PathComponent.self)!.pathMatrix)

    }
    
    func printMatrix(_ matrix: [[Any]]) { for i in 0 ..< matrix.count { print(matrix[i]) } }
    
    #if os(watchOS)
    override func sceneDidLoad() {r
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
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
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

