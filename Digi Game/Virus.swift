//
//  Virus.swift
//  Digi Game
//
//  Created by Nikola Bodor on 24/10/22.
//

import Foundation
import SpriteKit

class Virus: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "enemy")
        super.init(texture: texture, color: UIColor.black, size: texture.size())

        name = "enemy"
        size = CGSize(width: 175, height: 175)

        zPosition = 9

        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.contactTestBitMask = physicsBody!.collisionBitMask

        physicsBody?.affectedByGravity = true
        physicsBody?.friction = 1000
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

