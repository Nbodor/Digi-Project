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
    private var controls: Controls!
    
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
    
    
    
    
    override init(size: CGSize) {
        playerSprites = SpriteSheet(imageNamed: "player", rows: 3, cols: 8)
        player = SKSpriteNode(texture: playerSprites.texture(row: PlayerPosture.standing.row, col: PlayerPosture.standing.col))
        super.init(size: size)
        controls = Controls(scene: self)
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
        addGround()
        addEnemy()
        
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
    
    private func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.size = CGSize(width: 200, height: 200)
        enemy.position = CGPoint(x: size.width - enemy.size.width / 2, y: size.height / 4)
        enemy.zPosition = 9
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2 - 8)
        enemy.physicsBody?.contactTestBitMask = enemy.physicsBody!.collisionBitMask
        
        enemy.physicsBody?.affectedByGravity = true
        
        
//        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
//        let deleteEnemy = SKAction.removeFromParent()
//        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
//        enemy.run(enemySequence)
        
        
        addChild(enemy)
    }
    
    private func addPlayer() {
        player.position = CGPoint(x: size.width / 2, y: size.height / 4)
        player.setScale(1.5)
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
        
        player.physicsBody?.affectedByGravity = true
        
        
        addChild(player)
    }
    
    private func addGround() {
        let ground = SKNode()
        ground.position = CGPoint(x: size.width / 2, y: player.position.y - player.size.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        ground.physicsBody?.isDynamic = false
        addChild(ground)
    }
    
    private func addControls() {
        addChild(controls.up)
        addChild(controls.right)
        addChild(controls.left)
    }
    
    private func right() {
        player.position.x += 100
    }
    
    private func left() {
        player.position.x -= 100
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
//        if touch location inside up button
        
        if touches.isEmpty { return }
        let touch = touches.first!.location(in: self)
        
        if atPoint(touch) == controls.left {
            left()
        }
        
        if atPoint(touch) == controls.right {
            right()
        }
        
        if atPoint(touch) == controls.up {
            jump()
        }
        
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
