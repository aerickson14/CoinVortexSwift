//
//  GameViewController.swift
//  CoinVortex2
//
//  Created by Andrew Erickson on 2022-01-29.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else { return }

        view.ignoresSiblingOrder = true

        let scene = GameScene(size: view.frame.size)
        scene.scaleMode = .aspectFill

        view.presentScene(scene)
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
