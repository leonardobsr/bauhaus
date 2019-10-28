//
//  LabelComponent.swift
//  Bauhaus iOS
//
//  Created by Leonardo Reis on 23/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class LabelComponent : GKComponent {
 
    var labelNode : SKLabelNode

    init(labelNode: SKLabelNode) {
       self.labelNode = labelNode
       super.init()
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
}
