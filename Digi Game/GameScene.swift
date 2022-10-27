//
//  GameScene.swift
//  Digi Game
//
//  Created by Nikola Bodor on 26/09/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private let playerSprites = SpriteSheet(imageNamed: "player", rows: 3, cols: 8)
//    private let playerTextures = SpriteSheet(imageNamed: "player", rows: 3, cols: 8).toAtlas()

    
    override func didMove(to view: SKView) {
        addBackground()
        addPlayer()
    }
    
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: size.width, height: size.height)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = 0
        addChild(background)
    }
    
    private func addPlayer() {
//        let player = SKSpriteNode(texture: playerTextures.textureNamed("frame_2_3"))
        let player = SKSpriteNode(texture: playerSprites.texture(row: 0, col: 3))
        player.position = CGPoint(x: size.width/4, y: 0)
//        player.position = CGPoint(x: size.width/2, y: size.height/2)
        player.size = CGSize(width: size.width / 10, height: size.height / 10)
        player.zPosition = 1
        addChild(player)
        
//        let animation
//        SKAction.repeatForever(animation)
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
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
//background.zRotation = Double.pi / 2
//let player = SKLabelNode(imageNamed: String""))
