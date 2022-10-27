//
//  Player.swift
//  Digi Game
//
//  Created by Nikola Bodor on 24/10/22.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    private let sprites: SpriteSheet
    
    init() {
        sprites = SpriteSheet(imageNamed: "player", rows: 3, cols: 8)
        super.init(texture: sprites.texture(row: Posture.standing.row, col: Posture.standing.col))
        
        position = CGPoint(x: size.width / 2, y: size.height / 4)
        setScale(1.5)
        zPosition = 1
        
        // Walking
        let frames = sprites.textureRow(row: Animation.walking.rawValue) + sprites.textureRow(row: Animation.misc.rawValue)[0...2]
        let animation = SKAction.animate(with: frames, timePerFrame: 0.09)
        
        // Running
//        let frames = playerSprites.textureRow(row: PlayerAnimation.running.rawValue)
//        let animation = SKAction.animate(with: frames, timePerFrame: 0.07)
        
        run(SKAction.repeatForever(animation))
        
        physicsBody = SKPhysicsBody(texture: frames[0], size: size)
        physicsBody!.contactTestBitMask = physicsBody!.collisionBitMask
//        physicsBody?.isDynamic = true  // default already
        
        physicsBody?.affectedByGravity = true
    }
    
    private enum Animation: Int {
        case misc = 0
        case running = 2
        case walking = 1
    }
    
    struct Posture {
        static let standing = (row: Animation.misc.rawValue, col: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
