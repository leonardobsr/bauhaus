//
//  IndexComponent.swift
//  Bauhaus
//
//  Created by Rovane Moura on 06/11/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import GameplayKit

class IndexComponent : GKComponent {
    
    var x : Int
    var y : Int
    var orientation : LineOrientation
    
    init(x: Int, y: Int, orientation: LineOrientation) {
        self.x = x
        self.y = y
        self.orientation = orientation
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getConnectedDotsIndex() -> (firstDot: (x: Int,y: Int), secondDot: (x: Int,y: Int)) {
        print(orientation)
        switch orientation {
        case .horizontal : return ((self.y,self.x), (self.y,self.x + 1))
        case .vertical : return ((self.y,self.x), (self.y + 1,self.x))
        }
    }
    
}
