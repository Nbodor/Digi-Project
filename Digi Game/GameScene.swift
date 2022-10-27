//
//  GameScene.swift
//  Digi Game
//
//  Created by Nikola Bodor on 26/09/22.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene, SKPhysicsContactDelegate {
    private let player = Player()
    private let ground = SKNode()
    private var controls: Controls!
    private let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    private let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    private var gameScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(gameScore)"
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        controls = Controls(scene: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct PhysicsCategories {
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 //1
        static let Virus: UInt32 = 0b10 //2
        static let Ground: UInt32 = 0b100 //4
    }
    
    override func didMove(to view: SKView) {
        addBackground()
        addGround()
        addPlayer()
        addControls()
        addLabels()
        startLevel()
        
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
    
    
    private func spawnEnemy() {
        let enemy = Virus()
        enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: ground.position.y + enemy.size.height / 2)
   
        addChild(enemy)
        
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Virus
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.Ground
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        enemy.physicsBody?.applyImpulse(CGVector(dx: -1500, dy: 0))

        enumerateChildNodes(withName: "enemy") {
            node, _ in
            
            if node.position.x < -node.frame.width {
                node.removeFromParent()
                self.addScore()
            }
        }
    }
    
    func addScore() {
        gameScore += 1
//        scoreLabel.text = "Score: \(gameScore)"
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
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 5)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForver = SKAction.repeatForever(spawnSequence)
        self.run(spawnForver)
    }
    
    private func addPlayer() {
        player.position = CGPoint(x: size.width / 2, y: ground.position.y + player.size.height / 2)
        player.groundLevel = ground.position.y
        
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.Ground
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Virus
        
        addChild(player)
    }
    
    private func addGround() {
        ground.position = CGPoint(x: size.width / 2, y: 50)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: 1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody!.categoryBitMask = PhysicsCategories.Ground
        addChild(ground)
    }
    
    private func addControls() {
        addChild(controls.up)
        addChild(controls.right)
        addChild(controls.left)
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
        if touches.isEmpty { return }
        let touch = touches.first!.location(in: self)
        
        switch (atPoint(touch)) {
        case controls.left: player.left()
        case controls.right: player.right()
        case controls.up: player.jump()
        default: break
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
    
    
    private func restartLevel() {
        enumerateChildNodes(withName: "enemy") {
            node, _ in node.removeFromParent()
        }
        player.reset()
    }
    
    private func loseLife() {
        // TODO: decrease life counter
        restartLevel()
        // TODO: play animation
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
//        if contact.bodyA
        loseLife()
    }
}
