//
//  Player.swift
//  Digi Game
//
//  Created by Nikola Bodor on 24/10/22.
//

import Foundation
import SpriteKit

/// Sets how much of a jump the player gets
private let JUMP_VECTOR = CGVector(dx: 0, dy: 450)
/// Sets the player size, if the player is affected by gravity, the physics body, where the player spawns and which textures to use for walking or running
class Player: SKSpriteNode {
    private let sprites: SpriteSheet /// 
    public var groundLevel: CGFloat = 0
    
    init() {
        sprites = SpriteSheet(imageNamed: "player", rows: 3, cols: 8)
        
        // Walking
        let frames = sprites.textureRow(row: Animation.walking.rawValue) + sprites.textureRow(row: Animation.misc.rawValue)[0...2]
        let animation = SKAction.animate(with: frames, timePerFrame: 0.09)
        
        // Running
//        let frames = playerSprites.textureRow(row: PlayerAnimation.running.rawValue)
//        let animation = SKAction.animate(with: frames, timePerFrame: 0.07)
        
        super.init(texture: sprites.texture(row: Posture.standing.row, col: Posture.standing.col), color: UIColor.white, size: frames[0].size())
        
        setScale(1.5)
        zPosition = 1
        
        run(SKAction.repeatForever(animation))
        
        physicsBody = SKPhysicsBody(texture: frames[0], size: size)
        physicsBody!.contactTestBitMask = physicsBody!.collisionBitMask
//        physicsBody?.isDynamic = true  // default already
//        physicsBody?.mass = 80
        
        physicsBody?.affectedByGravity = true
    }
    
    func setGroundLevel(_ groundLevel: CGFloat) {
        self.groundLevel = groundLevel
    }
    /// Makes the player go back to its orignal Y and rotates him back to normal
    func reset() {
        position.y = groundLevel + size.height / 2
        zRotation = 0
    }
    /// Makes the player jump and get reset back to standing up, when it gets called whenever someone presses the up arrow button
    func jump() {
        // TODO: preload frames to avoid lag when jumping the first time
//        let frames = Array(playerSprites.textureRow(row: PlayerAnimation.misc.rawValue)[4...5])
//        let animation = SKAction.sequence([
//            SKAction.moveBy(x: 0, y: 300, duration: 0.1)
//        ])
//        player.run(animation)
        
        reset()
        physicsBody?.applyImpulse(JUMP_VECTOR)
    }
    /// Makes the player go right and get reset back to standing up, when it gets called whenever someone presses the right arrow button
    func right() {
        reset()
        position.x += 100
    }
    /// Makes the player go left and get reset back to standing up, when it gets called whenever someone presses the left arrow button
    func left() {
        reset()
        position.x -= 100
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
