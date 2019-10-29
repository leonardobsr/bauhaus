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

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let scene = GameScene.newGameScene()
//        let scene = StartScene()
//        let scene = ChooseCPScene.newChooseCPScene()

//         Present the scene
//        let skView = self.view as! SKView
//        skView.presentScene(scene)
//
//        skView.ignoresSiblingOrder = true
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        
//                let scene = MenuScene.newGameScene()
//                let skView = self.view as! SKView
//                skView.presentScene(scene)
//
//                skView.ignoresSiblingOrder = true
//                skView.showsFPS = true
//                skView.showsNodeCount = true
        
        
        let gameManager = GameManager.shared
        gameManager.gameViewController = self
        gameManager.startGame()
        //gameManager.nextScreen()
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
}
