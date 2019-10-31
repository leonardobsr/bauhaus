//
//  SKNodeExtension.swift
//  Bauhaus iOS
//
//  Created by Leonardo Reis on 31/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import SpriteKit

public extension SKNode {

    func posByScreen(x: CGFloat, y: CGFloat) {
        self.position = CGPoint(x: CGFloat((SKViewSizeRect!.width * x) + SKViewSizeRect!.origin.x), y: CGFloat((SKViewSizeRect!.height * y) + SKViewSizeRect!.origin.y))
    }
}