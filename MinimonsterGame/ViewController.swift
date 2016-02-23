//
//  ViewController.swift
//  MinimonsterGame
//
//  Created by Norio Egi on 2/15/16.
//  Copyright © 2016 Capotasto. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var leashImg: DragImg!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    @IBOutlet weak var replayBg: UIView!
    @IBOutlet weak var replayBtn: UIButton!
    @IBOutlet weak var bigMonsterBtn: UIButton!
    @IBOutlet weak var smallMonsterBtn: UIButton!
    @IBOutlet weak var backGroundImg: UIImageView!
    
    let DIM_ALPAH: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    var chosenMonster = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replayBg.hidden = false
        bigMonsterBtn.hidden = false
        smallMonsterBtn.hidden = false
    }
    
    @IBAction func onTappedReplayBtn(sender: AnyObject) {
        initTask();
        monsterImg.image = UIImage(named: "\(chosenMonster)idle1.png")
        penalties = 0
        replayBtn.hidden = true
        replayBg.hidden = true
    
    }
    
    @IBAction func onTappedBigMonsterBtn(sender: AnyObject) {
        chosenMonster = "big_"
        monsterImg.hidden = false
        replayBg.hidden = true
        bigMonsterBtn.hidden = true
        smallMonsterBtn.hidden = true
        backGroundImg.image = UIImage(named:"bg.png")

        initTask()
    }
    
    @IBAction func onTappedSmallMonsterBtn(sender: AnyObject) {
        chosenMonster = "small_"
        monsterImg.hidden = false
        replayBg.hidden = true
        bigMonsterBtn.hidden = true
        smallMonsterBtn.hidden = true
        backGroundImg.image = UIImage(named:"gray_tile2.png")

        initTask()
    }
    
    func initTask(){
        monsterImg.playIdleAnimation(chosenMonster)
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        leashImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPAH
        penalty2Img.alpha = DIM_ALPAH
        penalty3Img.alpha = DIM_ALPAH
        heartImg.alpha = OPAQUE
        foodImg.alpha = OPAQUE
        leashImg.alpha = OPAQUE
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do{
            let resourcePath = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
            try musicPlayer = AVAudioPlayer(contentsOfURL: url)
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
        
        startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject){
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPAH
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPAH
        heartImg.userInteractionEnabled = false
        leashImg.alpha = DIM_ALPAH
        leashImg.userInteractionEnabled = false
        
        if currentItem == 0{
            sfxHeart.play()
        }else if currentItem == 1{
            sfxBite.play()
        }else {
            sfxHeart.play()
        }
    }
    
    func startTimer(){
        if timer != nil{
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
        
    }
    
    func changeGameState(){
        
        if !monsterHappy{
            penalties++
            
            sfxSkull.play()
            
            if penalties == 1{
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPAH
            }else if penalties == 2{
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPAH
            } else if penalties >= 3{
                penalty3Img.alpha = OPAQUE
            } else{
                penalty1Img.alpha = DIM_ALPAH
                penalty2Img.alpha = DIM_ALPAH
                penalty2Img.alpha = DIM_ALPAH
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
                showReplayBtn()
            }

        }
        
        let rand = arc4random_uniform(3)//0 or 1 or 2
        
        if rand == 0{
            foodImg.alpha = DIM_ALPAH
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
            
            leashImg.alpha = DIM_ALPAH
            leashImg.userInteractionEnabled = false
            
        } else if rand == 1{
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
            
            heartImg.alpha = DIM_ALPAH
            heartImg.userInteractionEnabled = false

            leashImg.alpha = DIM_ALPAH
            leashImg.userInteractionEnabled = false
        }else{
            foodImg.alpha = DIM_ALPAH
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = DIM_ALPAH
            heartImg.userInteractionEnabled = false
            
            leashImg.alpha = OPAQUE
            leashImg.userInteractionEnabled = true

        }
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver(){
        timer.invalidate()
        sfxDeath.play()
        monsterImg.playDeathAnimation(chosenMonster)
    }
    
    func showReplayBtn(){
        replayBg.hidden = false
        replayBg.userInteractionEnabled = true
        replayBtn.hidden = false
        replayBtn.userInteractionEnabled = true
    }
    
    
}

