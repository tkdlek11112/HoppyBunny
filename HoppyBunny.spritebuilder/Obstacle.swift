//
//  Obstacle.swift
//  HoppyBunny
//
//  Created by Cho on 2016. 4. 24..
//  Copyright © 2016년 Apportable. All rights reserved.
//

import Foundation

class Obstacle : CCNode {
    weak var topCarrot : CCNode!
    weak var bottomCarrot : CCNode!
    
    let topCarrotMinimumPostionY : CGFloat = 128
    let bottomCarrotMaximumPostionY : CGFloat = 440
    let carrotDistance : CGFloat = 142
    
    func setupRandomPosition() {
        let randomPrecision : UInt32 = 100
        let random = CGFloat(arc4random_uniform(randomPrecision)) / CGFloat(randomPrecision)
        let range = bottomCarrotMaximumPostionY - carrotDistance - topCarrotMinimumPostionY
        topCarrot.position = ccp(topCarrot.position.x, topCarrotMinimumPostionY + (random * range));
        bottomCarrot.position = ccp(bottomCarrot.position.x, topCarrot.position.y + carrotDistance);
    }
    
    func didLoadFromCCB() {
        topCarrot.physicsBody.sensor = true
        bottomCarrot.physicsBody.sensor = true
    }
}