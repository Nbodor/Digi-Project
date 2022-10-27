//
//  Controls.swift
//  Digi Game
//
//  Created by Nikola Bodor on 24/10/22.
//

import Foundation
import SpriteKit

class Controls {
    let left, right, up: SKSpriteNode
    
    init(scene: GameScene) {
        left = SKSpriteNode(imageNamed: "arrow")
        let arrowAspectRatio: Double = left.size.width / left.size.height
        left.size = CGSize(width: 100, height: 100 / arrowAspectRatio)
        left.position = CGPoint(x: 100, y: 100)
        left.zPosition = 10
        left.alpha = 0.5
        left.zRotation = Double.pi
        
        right = SKSpriteNode(imageNamed: "arrow")
        right.size = CGSize(width: 100, height: 100 / arrowAspectRatio)
        right.position = CGPoint(x: 250, y: 100)
        right.zPosition = 10
        right.alpha = 0.5
        right.zRotation = 0
        
        up = SKSpriteNode(imageNamed: "arrow")
        up.size = CGSize(width: 100, height: 100)
        up.position = CGPoint(x: scene.size.width - 100, y: 100)
        up.zRotation = Double.pi / 2
        up.alpha = 0.45
        up.zPosition = 10
    }
}
