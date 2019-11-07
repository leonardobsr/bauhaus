//
//  GridComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 07/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class GridComponent : GKComponent {
    
    var gridNode : SKNode
    
    var dotGrid : [[Dot]]
    var lastConnectedDots : Set<Dot>
    
    var lastHoveredLines : [Line]
    
    var horizontalLineGrid : [[Line]]
    
    var verticalLineGrid : [[Line]]
    
    
    init(gridNode: SKNode) {
        self.gridNode = gridNode
        self.dotGrid = []
        self.lastConnectedDots = []
        self.lastHoveredLines = []
        self.horizontalLineGrid = []
        self.verticalLineGrid = []
        
        super.init()
    }
    
    func setGrid(width: Int, height: Int, size: CGSize) {
        // Set Dots
        var dotRow : [Dot]
        let dotDistanceX : CGFloat = 56
        let dotDistanceY : CGFloat = 56

        for i in 0 ..< height {
            dotRow = []
            for j in 0 ..< width {
                let newDot = Dot()
                if let renderNode = newDot.component(ofType: RenderComponent.self)?.node {
                    self.gridNode.addChild(renderNode)
                    renderNode.position = CGPoint(x: (CGFloat(j) * dotDistanceX) - size.width/2,
                                                  y: (CGFloat(i) * dotDistanceY) - size.height/2)
                }
                dotRow.append(newDot)
            }
            self.dotGrid.append(dotRow)
        }
        
        // Set H-Lines
        var hLineRow : [Line] = []
        for i in 0 ..< height {
            hLineRow = []
            for j in 0 ..< (width - 1) {
                let newHLine = Line(.horizontal, index: (j,i))
                if let renderNode = newHLine.component(ofType: RenderComponent.self)?.node {
                    self.gridNode.addChild(renderNode)
                    renderNode.position = CGPoint(x: ((CGFloat(j) * dotDistanceX) + dotDistanceX/2) - size.width/2 , y: (CGFloat(i) * dotDistanceY) - size.height/2)
                }
                hLineRow.append(newHLine)
            }
            self.horizontalLineGrid.append(hLineRow)
        }
        
        // Set V-Lines
        var vLineRow : [Line] = []
        for i in 0 ..< (height - 1) {
            vLineRow = []
            for j in 0 ..< width {
                let newVLine = Line(.vertical, index: (j,i))
                if let renderNode = newVLine.component(ofType: RenderComponent.self)?.node {
                    self.gridNode.addChild(renderNode)
                    renderNode.position = CGPoint(x: (CGFloat(j) * dotDistanceX) - size.width/2 , y: ((CGFloat(i) * dotDistanceY) + dotDistanceY/2) - size.height/2)
                }
                vLineRow.append(newVLine)
            }
            self.verticalLineGrid.append(vLineRow)
        }
        
//        for _ in 0 ... 50 {
//            self.verticalLineGrid.randomElement()!.randomElement()!.component(ofType: LightSwitchComponent.self)?.turnOn()
//        }
//
//        for _ in 0 ... 50 {
//            self.horizontalLineGrid.randomElement()!.randomElement()!.component(ofType: LightSwitchComponent.self)?.turnOn()
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func connect(firstDot: (x: Int, y: Int), to secondDot: (x: Int, y: Int)) {
        // left to right, down up
        
        let first = dotGrid[firstDot.x][firstDot.y]
        let second = dotGrid[secondDot.x][secondDot.y]
        
        if firstDot.x < secondDot.x {
            first.component(ofType: ConnectionComponent.self)?.connect(direction: .right, to: second)
//            print("Connected (\(firstDot.x),\(firstDot.y)) > (\(secondDot.x),\(secondDot.y))")
            
            second.component(ofType: ConnectionComponent.self)?.connect(direction: .left, to: first)
//            print("Connected (\(secondDot.x),\(secondDot.y)) > (\(firstDot.x),\(firstDot.y))")
            
            lastConnectedDots.insert(first)
            lastConnectedDots.insert(second)
        } else if firstDot.y < secondDot.y {
            first.component(ofType: ConnectionComponent.self)?.connect(direction: .up, to: second)
//            print("Connected (\(firstDot.x),\(firstDot.y)) ^ (\(secondDot.x),\(secondDot.y))")
            
            second.component(ofType: ConnectionComponent.self)?.connect(direction: .down, to: first)
//            print("Connected (\(secondDot.x),\(secondDot.y)) v (\(firstDot.x),\(firstDot.y))")
            
            lastConnectedDots.insert(first)
            lastConnectedDots.insert(second)
        }
        
    }
    
}
