//
//  ConnectionComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 04/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class ConnectionComponent : GKComponent {
    
    private var connections : [Direction : Dot]
    
    override init() {
        self.connections = [:]
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func connect(direction: Direction, to dot: Dot ) {
        self.connections[direction] = dot
    }
    
    func disconnect(direction: Direction) {
        self.connections.removeValue(forKey: direction)
    }
    
}
