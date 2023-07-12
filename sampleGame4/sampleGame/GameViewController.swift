//
//  GameViewController.swift
//  sampleGame
//
//  Created by kunren on 2020/05/20.
//  Copyright © 2020 若師高志. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // 640 × 1136サイズのゲームシーンを作ります
        let scene = GameScene(size: CGSize(width: 640, height: 1136))
        
        // Main.storyboardのViewをSKViewとしてアクセスします。
        let skView = self.view as! SKView
        
        // 画面のモードを、画面サイズにフィットするように拡大縮小するモードにします。
        scene.scaleMode = .aspectFit
        
        // SKViewにそのシーンを表示します
        skView.presentScene(scene)
        
        
        //let mySprite = SKSpriteNode(imageNamed: "DQ")
        /*
        let myTexture = SKTexture(imageNamed: "DQ")
        let mySprite = SKSpriteNode(texture: myTexture, size: CGSize(width: 350, height: 350))
        
        mySprite.size = CGSize(width: 200, height: 200)
        mySprite.position = CGPoint(x: 100, y: 100)
        
        let myShape = SKShapeNode(circleOfRadius: 20)
        
        self.addChild(mySprite)
        */
        
        
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
