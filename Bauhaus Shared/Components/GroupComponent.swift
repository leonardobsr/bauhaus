//
//  GroupComponent.swift
//  Bauhaus
//
//  Created by Leonardo Reis on 28/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class GroupComponent : GKComponent {
 
    var node : SKNode

    init(node: SKNode) {
       self.node = node
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
