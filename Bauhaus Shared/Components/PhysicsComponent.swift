//
//  File.swift
//  Bauhaus
//
//  Created by Rovane Moura on 05/11/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class PhysicsComponent : GKComponent {
    
    enum ContactMask : UInt32 {
        case gamePiece = 1
        case boardLine = 2
        
        func contactTestBitMask() -> ContactMask {
            switch self {
            case .gamePiece : return .boardLine
            case .boardLine : return .gamePiece
            }
        }
    }
 
    var node : SKSpriteNode

    init(node: SKSpriteNode, categoryBitMask: ContactMask) {
        self.node = node
        if let texture = self.node.texture {
            if categoryBitMask == .boardLine {
                self.node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 7))
//                self.node.physicsBody = SKPhysicsBody(circleOfRadius: 7)
                self.node.physicsBody?.isDynamic = false
            } else {
                self.node.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
                self.node.physicsBody?.isDynamic = true
            }
            self.node.physicsBody?.usesPreciseCollisionDetection = true
            self.node.physicsBody?.affectedByGravity = false
            self.node.physicsBody?.categoryBitMask = categoryBitMask.rawValue
            self.node.physicsBody?.contactTestBitMask = categoryBitMask.contactTestBitMask().rawValue
            self.node.physicsBody?.collisionBitMask = 0
        }
        
       super.init()
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    func setChilds(childs: [GKEntity?]) {
        for child in childs {
            if let childNode = child?.component(ofType: RenderComponent.self)?.node {
                self.node.addChild(childNode)
            }
        }
    }
}
