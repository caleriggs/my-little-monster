//
//  ViewController.swift
//  my-little-monster
//
//  Created by Cale Riggs on 5/19/16.
//  Copyright © 2016 Cale Riggs. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var foodIMg: DragImg!
    @IBOutlet weak var hammerImg: DragImg!
    @IBOutlet weak var restartBtn: UIButton!
    
    
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
   
    @IBAction func resetGame(sender: AnyObject) {
        startTimer()
        restartBtn.hidden = true
        monsterImg.playIdleAnimation()
        penalties = 0
        penaltyImgStart()
    }
    
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var cavePlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxRocks: AVAudioPlayer!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        foodIMg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        hammerImg.dropTarget = monsterImg
        
        penaltyImgStart()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try cavePlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: ".mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            try sfxRocks = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("rocks", ofType: "wav")!))
            
            cavePlayer.prepareToPlay()
            cavePlayer.play()
            
            sfxHeart.prepareToPlay()
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    
        startTimer()
    }
    
    func penaltyImgStart(){
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
    }

    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodIMg.alpha = DIM_ALPHA
        foodIMg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        hammerImg.alpha = DIM_ALPHA
        hammerImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else if currentItem == 1{
            sfxBite.play()
        } else {
            sfxRocks.play()
        } 
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        if !monsterHappy {
        penalties += 1
            
        sfxSkull.play()
        
        if penalties == 1 {
            penalty1Img.alpha = OPAQUE
            penalty2Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
            penalty2Img.alpha = OPAQUE
            penalty3Img.alpha = DIM_ALPHA
            } else if penalties >= 3 {
            penalty3Img.alpha = OPAQUE
            } else {
            penalty1Img.alpha = DIM_ALPHA
            penalty2Img.alpha = DIM_ALPHA
            penalty3Img.alpha = DIM_ALPHA
            }
        
        if penalties >= MAX_PENALTIES {
            gameOver()
            }
        }
        
        let rand = arc4random_uniform(3)
        
        if rand == 0 {
            foodIMg.alpha = DIM_ALPHA
            foodIMg.userInteractionEnabled = false
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
            hammerImg.alpha = DIM_ALPHA
            hammerImg.userInteractionEnabled = false
        
            } else if rand == 1 {
            foodIMg.alpha = OPAQUE
            foodIMg.userInteractionEnabled = true
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            hammerImg.alpha = DIM_ALPHA
            hammerImg.userInteractionEnabled = false
            } else  {
            foodIMg.alpha = DIM_ALPHA
            foodIMg.userInteractionEnabled = false
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            hammerImg.alpha = OPAQUE
            hammerImg.userInteractionEnabled = true
            }
        
        currentItem = rand
        monsterHappy = false
        
    }
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
        restartBtn.hidden = false
    }
    
    
    
}


    



