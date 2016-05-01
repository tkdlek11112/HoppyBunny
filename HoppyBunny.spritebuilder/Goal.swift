//
//  Goal.swift
//  HoppyBunny
//
//  Created by Cho on 2016. 4. 24..
//  Copyright © 2016년 Apportable. All rights reserved.
//

import Foundation

class Goal: CCNode {
    func didLoadFromCCB() {
        physicsBody.sensor = true;
    }
}