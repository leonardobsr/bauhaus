//
//  Group.swift
//  Bauhaus
//
//  Created by Leonardo Reis on 23/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class Group : GKEntity {
    
    init(position: CGPoint) {
        super.init()
        
        let renderComponent = RenderComponent(node: SKNode())
        renderComponent.node.posByScreen(x: position.x, y: position.y)
        self.addComponent(renderComponent)
        
        let groupComponent = GroupComponent(node: renderComponent.node)
        self.addComponent(groupComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setChilds(childs: [GKEntity?]) {
        guard let _ = self.component(ofType: GroupComponent.self)?.node else {
            return;
        }
        
        self.component(ofType: GroupComponent.self)?.setChilds(childs: childs);
    }
    
}
