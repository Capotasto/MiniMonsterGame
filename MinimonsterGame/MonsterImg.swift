//
//  MonsterImg.swift
//  MinimonsterGame
//
//  Created by Norio Egi on 2/19/16.
//  Copyright © 2016 Capotasto. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //playIdleAnimation()
    }
    
    func playIdleAnimation(bigOrSmall: String){
        
        self.image = UIImage(named: "\(bigOrSmall)idle1.png")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "\(bigOrSmall)idle\(x).png")
            imgArray.append(img!)
            
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()

    }
    
    func playDeathAnimation(bigOrSmall: String){
        
        self.image = UIImage(named: "\(bigOrSmall)dead5.png")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var x = 1; x <= 5; x++ {
            let img = UIImage(named: "\(bigOrSmall)dead\(x).png")
            imgArray.append(img!)
            
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()

    }
}