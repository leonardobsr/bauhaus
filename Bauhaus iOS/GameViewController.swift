//
//  GameViewController.swift
//  Bauhaus iOS
//
//  Created by Leonardo Reis on 02/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var SKViewSize: CGSize?
var SKViewSizeRect: CGRect?

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        SKViewSize = skView.bounds.size
        skView.showsPhysics = true
        
        if let skViewSize = SKViewSize {
            SKViewSizeRect = getViewSizeRect()
//            let scene = ChooseCPScene.newChooseCPScene(size: skViewSize)
//            skView.presentScene(scene)
        }
        
        let gameManager = GameManager.shared
        gameManager.gameViewController = self
        gameManager.startGame()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        SKViewSize = self.view.bounds.size
        SKViewSizeRect = getViewSizeRect()

        let skView = self.view as! SKView
        if let scene = skView.scene {
            if scene.size != self.view.bounds.size {
                scene.size = self.view.bounds.size
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getViewSizeRect() -> CGRect {
        return CGRect(x: ((SKViewSize!.width  * 0.5) * -1.0), y: ((SKViewSize!.height * 0.5) * -1.0), width: SKViewSize!.width, height: SKViewSize!.height)
    }
}
