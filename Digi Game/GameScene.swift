//
//  GameScene.swift
//  Digi Game
//
//  Created by Nikola Bodor on 26/09/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let playerSprites: SpriteSheet
    private let player: SKSpriteNode
    
    
    override init(size: CGSize) {
        playerSprites = SpriteSheet(imageNamed: "player", rows: 3, cols: 8)
        player = SKSpriteNode(texture: playerSprites.texture(row: PlayerPosture.standing.row, col: PlayerPosture.standing.col))
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum PlayerAnimation: Int {
        case misc = 0
        case running = 2
        case walking = 1
    }
    
    struct PlayerPosture {
        static let standing = (row: PlayerAnimation.misc.rawValue, col: 3)
    }
    
    
    override func didMove(to view: SKView) {
        addBackground()
        addPlayer()
        addControls()
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
    }
    
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: size.width, height: size.height)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 0
//        background.zRotation = Double.pi / 2
        addChild(background)
    }
    
    private func addPlayer() {
        player.position = CGPoint(x: size.width/2, y: size.height/4)
        player.size = CGSize(width: player.size.width*1.5, height: player.size.height*1.5)
        player.zPosition = 1
        
        // Walking
        let frames = playerSprites.textureRow(row: PlayerAnimation.walking.rawValue) + playerSprites.textureRow(row: PlayerAnimation.misc.rawValue)[0...2]
        let animation = SKAction.animate(with: frames, timePerFrame: 0.09)
        
        // Running
//        let frames = playerSprites.textureRow(row: PlayerAnimation.running.rawValue)
//        let animation = SKAction.animate(with: frames, timePerFrame: 0.07)
        
        player.run(SKAction.repeatForever(animation))
        
        player.physicsBody = SKPhysicsBody(texture: frames[0], size: player.size)
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
//        player.physicsBody?.isDynamic = true  // default already
        
        player.physicsBody?.affectedByGravity = false
        
        
        addChild(player)
    }
    
    private func addControls() {
        
        let left = SKSpriteNode(imageNamed: "arrow")
        left.size = CGSize(width: 100, height: 100)
        left.position = CGPoint(x: 100, y: 100)
        left.zPosition = 10
        
        addChild(left)
        
    }
    
    
    private func jump() {
        // TODO: preload frames to avoid lag when jumping the first time
        let frames = Array(playerSprites.textureRow(row: PlayerAnimation.misc.rawValue)[4...5])
        let animation = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 100, duration: 0.1)
        ])
        player.run(animation)
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        jump()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
