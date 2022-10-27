//
//  GameScene.swift
//  Digi Game
//
//  Created by Nikola Bodor on 26/09/22.
//

import SpriteKit
import GameplayKit


private let JUMP_VECTOR = CGVector(dx: 0, dy: 325)


class GameScene: SKScene, SKPhysicsContactDelegate {
    private let player = Player()
    private let ground = SKNode()
    private var controls: Controls!
    private var gameScore = 0
    private let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    private let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
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
        super.init(size: size)
        controls = Controls(scene: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        addBackground()
        addPlayer()
        addControls()
        addGround()
        addLabels()
        startLevel()
        
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
        enemy.name = "Enemy"
        enemy.size = CGSize(width: 175, height: 175)
        enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: ground.position.y + enemy.size.height / 2)
        enemy.zPosition = 9
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2)
        enemy.physicsBody?.contactTestBitMask = enemy.physicsBody!.collisionBitMask
        
        enemy.physicsBody?.affectedByGravity = true
        enemy.physicsBody?.friction = 1000
        
        addChild(enemy)
        
        enemy.physicsBody?.applyImpulse(CGVector(dx: -1500, dy: 0))

        enumerateChildNodes(withName: "Enemy") {
            node, _ in
            
            if node.position.x < -node.frame.width {
                node.removeFromParent()
                self.addScore()
            }
        }
    }
    
    func addScore() {
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
    }
    
    private func addLabels() {
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.black
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: size.width - 225 , y: size.height - 50)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 50
        livesLabel.fontColor = SKColor.black
        livesLabel.horizontalAlignmentMode = .right
        livesLabel.position = CGPoint(x: 185, y: size.height - 50)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
    }
    
    private func startLevel() {
        let spawn = SKAction.run(addEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 5)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForver = SKAction.repeatForever(spawnSequence)
        self.run(spawnForver)
    }
    
    private func addPlayer() {
        addChild(player)
    }
    
    private func addGround() {
        ground.position = CGPoint(x: size.width / 2, y: player.position.y - player.size.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: 1))
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
//        let frames = Array(playerSprites.textureRow(row: PlayerAnimation.misc.rawValue)[4...5])
//        let animation = SKAction.sequence([
//            SKAction.moveBy(x: 0, y: 300, duration: 0.1)
//        ])
//        player.run(animation)
        
        player.zRotation = 0
        player.physicsBody?.applyImpulse(JUMP_VECTOR)
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
        
//        addEnemy()
        
//        enemy.physicsBody?.applyImpulse(CGVector(dx: -1750, dy: 0))
        
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
