//
//  GameScene.swift
//  sampleGame
//
//  Created by kunren on 2020/05/20.
//  Copyright © 2020 若師高志. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    
    var timer : Timer?
    var count = 0
    let settingKey = "timer_value"
    
    // ランダムを使う準備をします
    let randomSource = GKARC4RandomSource()
    
    // 間違い番号の変数を用意します
    var mistakeNo = 0
    
    var seikaiCount:Int = 0
    
    var machigaiCount:Int = 0
    
    var timerCount:Int = 0
    
    var startDate = NSDate()
    
    let msgLabel = SKLabelNode(fontNamed: "HiraKaKuProN-W3")
    
    let zanLalbel = SKLabelNode(fontNamed: "HiraKaKuProN-W3")
    
    let seigLabel = SKLabelNode(fontNamed: "HiraKaKuProN-W3")
    
    let scrLabel = SKLabelNode(fontNamed: "HiraKaKuProN-W3")
    
    let tmrLabel = SKLabelNode(fontNamed: "HiraKaKuProN-W3")
    
    let tmtextLabel = SKLabelNode(fontNamed: "HiraKaKuProN-W3")
    
    let rtryLabel = SKLabelNode(fontNamed: "HiraKaKuProN-W3")
    
    
    var msg:String = "違う漢字をタッチしよう"
    
    var zan:String = "残20問"
    
    var seigo:String = "正解数　不正解数"
    
    var scr:String = ""
    
    var tmr:Int = 0
    
    var tmtext:String = ""
    
    var rtry:String = ""
    
    // 漢字を入れるボール数を６個にします
    let ballMax = 15
    
    // ボールを入れておく配列を用意します
    var ballList:[SKShapeNode] = []
    
    // 問題を配列で用意します
    var correct = [
        "人","巳","氷","体","坂",
        "祝","間","困","理","科",
        "待","猫","鳥","楽","簿",
        "緑","塊","幕","態","微"]
    var mistake = [
        "入","己","水","休","板",
        "呪","問","因","埋","料",
        "侍","錨","烏","薬","薄",
        "縁","魂","慕","熊","徴"]
    
    // 問題の番号の変数を用意します
    var questionNo = 0
    
    //var timer = Timer()
    //var count:Int = 0
    
    override func didMove(to view: SKView) {
        
        // 物理シュミレーション空間を画面サイズで作ります
            self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
            
            // 空間の周囲の反発力を少し上げます
            self.physicsBody?.restitution = 1.2
            
            // 背景を自由に決めます
            self.backgroundColor = UIColor.systemTeal
            // 正解や不正解の説明ラベルを表示します。
            msgLabel.text = msg
            msgLabel.fontSize = 36
            msgLabel.fontColor = UIColor.red
            msgLabel.position = CGPoint(x: 320, y: 1080)
            self.addChild(msgLabel)
            
            // 残り問題数ラベルを表示します。
            zanLalbel.text = zan
            zanLalbel.fontSize = 36
            zanLalbel.fontColor = UIColor.yellow
            zanLalbel.position = CGPoint(x: 160, y: 980)
            self.addChild(zanLalbel)
            
            // 正解と不正解の数を表示します。
            seigLabel.text = seigo
            seigLabel.fontSize = 36
            seigLabel.fontColor = UIColor.magenta
            seigLabel.position = CGPoint(x: 320, y: 880)
            self.addChild(seigLabel)
            
            
            // 経過時間ラベルを表示します。
            tmrLabel.text = String(tmr)
            tmrLabel.fontSize = 36
            tmrLabel.fontColor = UIColor.brown
            tmrLabel.position = CGPoint(x: 480, y: 980)
            self.addChild(tmrLabel)
            
            // スコアラベルを表示します。
            scrLabel.text = scr
            scrLabel.fontSize = 50
            scrLabel.fontColor = UIColor.white
            scrLabel.position = CGPoint(x: 320, y: 750)
            self.addChild(scrLabel)
            
            // 時間経過の判定コメントラベルを表示します。
            tmtextLabel.text = tmtext
            tmtextLabel.fontSize = 50
            tmtextLabel.fontColor = UIColor.green
            tmtextLabel.position = CGPoint(x: 320, y: 630)
            self.addChild(tmtextLabel)
        
            // リトライの説明ラベルを表示します。
            rtryLabel.text = rtry
            rtryLabel.fontSize = 75
            rtryLabel.fontColor = UIColor.orange
            rtryLabel.position = CGPoint(x: 320, y: 40)
            self.addChild(rtryLabel)
            
            
            let setting = UserDefaults.standard
            setting.register(defaults: [settingKey:0])
            
            
            //tmrLabel.text = String(timer)
            //print(timer)
            
            if let nowTimer = timer {
                
                if nowTimer.isValid == true {
                    
                    return
                }
            }
            /* タイマー実行 */
            timer = Timer.scheduledTimer(
                timeInterval: 1.0,//実行する時間
                        target: self,
                        selector: #selector(self.timerInterrupt(_:)),  //実行関数
                        userInfo: nil,
                        repeats: true
            )
            
            newQuestion()
    
    }
    
    // 出題するメソッド
    func newQuestion() {
        
        if self.correct.count != 0 && self.mistake.count != 0 {
        
        // 問題番号を決めます
        questionNo = randomSource.nextInt(upperBound: correct.count)
        
        // 間違い番号をランダムに決めます
        mistakeNo = randomSource.nextInt(upperBound: ballMax)
        
        // ボールの配列をリセットします
        ballList = []
        
        // ballMax個のボールを作ります
        for loopID in 0..<ballMax {
            
            // ボールをシェイプノードで作ります
            let ball = SKShapeNode(circleOfRadius: 45)
            ball.fillColor = UIColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 1.0)
            ball.position = CGPoint(x: loopID * 100 + 70, y: 1000)
            
            // シーンに表示します
            self.addChild(ball)
            
            // ボールの配列に追加します
            ballList.append(ball)
            
            // 漢字を表示するラベルノードを作ります
            let kanji = SKLabelNode(fontNamed: "HiraKaKuProN-W6")
            
            // 問題の設定をします
            if loopID != mistakeNo {
                // もし、間違い番号でなければ正解の漢字を表示
                kanji.text = correct[questionNo]
            } else {
                // もし、間違いならば間違いの漢字を表示
                kanji.text = mistake[questionNo]
            }
            kanji.fontSize = 60
            kanji.fontColor = UIColor.black
            kanji.position = CGPoint(x: 0, y: -25)
            
            //　ボールに漢字を追加します
            ball.addChild(kanji)
            
            // 修正後
            // ボールを画面の上にランダムに配置します
            let wx = randomSource.nextInt(upperBound: 440) + 100
            let wy = randomSource.nextInt(upperBound: 200) + 800
            ball.position = CGPoint(x: wx, y: wy)
            
            // 円の物理シュミレーション物体を作って結びつけます
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 45)
            
            // ボールの反発力を少し上げます
            ball.physicsBody?.restitution = 0.9
            
            // ランダムに回転させます
            let angle = CGFloat(randomSource.nextUniform() * 6.28)
            ball.zRotation = angle
        }
        } else {
            doscore()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.correct.count == 0 && self.mistake.count == 0 {
            
          //syokika()
            // 640 × 1136サイズのゲームシーンを作ります
            let scene = GameScene(size: CGSize(width: 640, height: 1136))
            
            // Main.storyboardのViewをSKViewとしてアクセスします。
            let skView = self.view as! SKView
            
            // 画面のモードを、画面サイズにフィットするように拡大縮小するモードにします。
            scene.scaleMode = .aspectFit
            
            // SKViewにそのシーンを表示します
            skView.presentScene(scene)
            
            if let scene = SKScene(fileNamed: "GameScene") {
                
                self.view?.presentScene(scene)
            }
            
        }
        
        // 1つのタッチ情報を取り出します
        for touch in touches {
            
            // タッチした位置にあるノードを全て調べます
            let location = touch.location(in: self)
            let touchNodes = self.nodes(at: location)
            
            // ノード１つ１つについて調べます
            for tNode in touchNodes {
                
                // ボールの配列と比較して
                for loopID in 0..<ballMax {
                
                //タッチしたノードとボールが同じなら
                    if tNode == ballList[loopID] {
                        answerCheck(No: loopID)
                        break
                    }
            }
        }
      }
        
    }
        
        // チェックメソッド
        func answerCheck(No: Int) {
            
            if self.correct.count != 0 && self.mistake.count != 0 {
            
            // 番号が間違いなら正解、そうでないなら不正解を表示します。
            if No == mistakeNo {
                msg = "正解!\(correct[questionNo])と\(mistake[questionNo])でした"
                
                // 問題数削除
                self.correct.remove(at: questionNo)
                self.mistake.remove(at: questionNo)
                
                zan =
                "残\(correct.count)問"
                
                seikaiCount += 1
                
                seigo =
                "正解数\(seikaiCount) 不正解数\(machigaiCount)"
                
                
            } else {
                msg = "間違い。\(correct[questionNo])と\(mistake[questionNo])でした"
                
                // 問題数削除
                self.correct.remove(at: questionNo)
                self.mistake.remove(at: questionNo)
                
                zan =
                "残\(correct.count)問"
                
                machigaiCount += 1
                
                seigo =
                "正解数\(seikaiCount) 不正解数\(machigaiCount)"
            }
            msgLabel.text = msg
            zanLalbel.text = zan
            seigLabel.text = seigo
            
            // 画面上のボールを削除します。
            for loopID in 0..<ballMax {
                ballList[loopID].removeFromParent()
                
                
            }
                
            // 次の問題を出題します
            newQuestion()
                
            } else {
                
                doscore()
            }
        }
    
    func doscore() {
        
           //timer.invalidate()
        
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
        

            
            let scoer = (seikaiCount * 50) + (machigaiCount * 0)
            
            zan =
            "スコア \(scoer)"
            
            zanLalbel.text = zan
            
            switch scoer {
            case 1000:
                scr = "ミスターパーフェクト！！"
                scrLabel.text = scr
            case (801...999):
                scr = "ベテランの人ですか！！"
                scrLabel.text = scr
            case (500...800):
                scr = "アマチュアの人ですか！！"
                scrLabel.text = scr
            case (251...499):
                scr = "よく見てくださいよ！！"
                scrLabel.text = scr
            case (0...250):
                scr = "全然ダメのダメダメです！！"
                scrLabel.text = scr
            default:
                break
                
            }
        
        //var jikan = Int(remainCount)
        
        switch count {
        case 0...800:
            tmtext = "動体視力半端ない！！"
        case 81...150:
            tmtext = "早いにこした事はない！！"
        case 151...300:
            tmtext = "時間かかりすぎ"
        case 301...500:
            tmtext = "出直して！！"
        default:
            break
        }
        tmtextLabel.text = tmtext
        
        rtryLabel.numberOfLines = 5
        rtry = "もう一度\nやる勇気と\n根性があれば\n画面をタップで\nリトライ"
        
        rtryLabel.text = rtry
        
    }
        
    
    /*
    /* タイマー関数 */
    @objc func CountDown() {
        count += 1
        
    }
    */
    
    func displayUpdate() -> Int {
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        let remainCount = timerValue + count
        tmrLabel.text = "\(remainCount)秒経過"
        
        return remainCount
    }
    
    @objc func timerInterrupt(_ timer:Timer) {
        
        count += 1
        
        if displayUpdate() >= 1000 {
            
            count = 0
            
            timer.invalidate()
        }
        
        
    }
    
    /*
    // 問題の配列の初期化
    func syokika() {
        /*
        var msg:String = "違う漢字をタッチしよう"
        
        var zan:String = "残20問"
        
        var seigo:String = "正解数　不正解数"
        
        var scr:String = ""
        
        var tmr:Int = 0
        
        var tmtext:String = ""
        */
        
        
        // ボールを入れておく配列を用意します
        var ballList:[SKShapeNode] = []
        
        // 問題を配列で用意します
        var correct = [
            "人","巳","氷","体","坂",
            "祝","間","困","理","科",
            "待","猫","鳥","楽","簿",
            "緑","塊","幕","態","微"]
        
        var mistake = [
            "入","己","水","休","板",
            "呪","問","因","埋","料",
            "侍","錨","烏","薬","薄",
            "縁","魂","慕","熊","徴"]
        
        // 問題の番号の変数を用意します
        //var questionNo = 0
        
        // 物理シュミレーション空間を画面サイズで作ります
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // 空間の周囲の反発力を少し上げます
        self.physicsBody?.restitution = 1.2
        
        // 背景を白にします
        self.backgroundColor = UIColor.systemTeal
        // 正解や不正解の説明ラベルを表示します。
        msgLabel.text = msg
        msgLabel.fontSize = 36
        msgLabel.fontColor = UIColor.red
        msgLabel.position = CGPoint(x: 320, y: 1080)
        self.addChild(msgLabel)
        
        // 残り問題数ラベルを表示します。
        zanLalbel.text = zan
        zanLalbel.fontSize = 36
        zanLalbel.fontColor = UIColor.black
        zanLalbel.position = CGPoint(x: 160, y: 980)
        self.addChild(zanLalbel)
        
        // 正解と不正解の数を表示します。
        seigLabel.text = seigo
        seigLabel.fontSize = 36
        seigLabel.fontColor = UIColor.systemPink
        seigLabel.position = CGPoint(x: 320, y: 880)
        self.addChild(seigLabel)
        
        
        // 経過時間ラベルを表示します。
        tmrLabel.text = String(tmr)
        tmrLabel.fontSize = 36
        tmrLabel.fontColor = UIColor.red
        tmrLabel.position = CGPoint(x: 480, y: 980)
        self.addChild(tmrLabel)
        
        // スコアラベルを表示します。
        scrLabel.text = scr
        scrLabel.fontSize = 50
        scrLabel.fontColor = UIColor.white
        scrLabel.position = CGPoint(x: 320, y: 780)
        self.addChild(scrLabel)
        
        // 時間経過の判定コメントラベルを表示します。
        tmtextLabel.text = tmtext
        tmtextLabel.fontSize = 50
        tmtextLabel.fontColor = UIColor.green
        tmtextLabel.position = CGPoint(x: 320, y: 680)
        self.addChild(tmtextLabel)
        
        
        let setting = UserDefaults.standard
        setting.register(defaults: [settingKey:0])
        
        
        //tmrLabel.text = String(timer)
        //print(timer)
        
        if let nowTimer = timer {
            
            if nowTimer.isValid == true {
                
                return
            }
        }
        /* タイマー実行 */
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,//実行する時間
                    target: self,
                    selector: #selector(self.timerInterrupt(_:)),  //実行関数
                    userInfo: nil,
                    repeats: true
        )
        
        newQuestion()
        
    }
 */

}
