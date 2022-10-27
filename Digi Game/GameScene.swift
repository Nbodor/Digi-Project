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
        let player = SKSpriteNode(texture: playerSprites.texture(row: PlayerPosture.standing.row, col: PlayerPosture.standing.col))
        player.position = CGPoint(x: size.width/2, y: size.height/4)
        player.size = CGSize(width: player.size.width*1.5, height: player.size.height*1.5)
        player.zPosition = 1
        
        let frames = playerSprites.textureRow(row: PlayerAnimation.walking.rawValue)
        let animation = SKAction.animate(with: frames, timePerFrame: 0.1)
        player.run(SKAction.repeatForever(animation))
        
        addChild(player)
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
