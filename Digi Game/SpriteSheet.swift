import Foundation
import SpriteKit


/// Picks a texture for running, walking, jumping or stantionary when it gets called
class SpriteSheet {
    private let name: String
    private let rows: Int
    private let cols: Int
    private let frameSize: CGSize
    private let sheet: SKTexture
    
    init(imageNamed name: String, rows: Int, cols: Int) {
        self.name = name
        self.rows = rows
        self.cols = cols
        self.frameSize = CGSize(width: 1.0 / CGFloat(cols), height: 1.0 / CGFloat(rows))
        self.sheet = SKTexture(imageNamed: name)
    }
    
    func texture(row: Int, col: Int) -> SKTexture {
        let x = CGFloat(col) / CGFloat(cols)
        let y = CGFloat(row) / CGFloat(rows) - 0.002  // fix image frame so it doesn't pick up the bottom of the next frame above
        let subtextureRect = CGRect(origin: CGPoint(x: x, y: y), size: frameSize)
        return SKTexture(rect: subtextureRect, in: sheet)
    }
    
    func textureRow(row: Int) -> [SKTexture] {
        var textures: [SKTexture] = []
        textures.reserveCapacity(cols)
        for i in 0..<cols {
            textures.append(texture(row: row, col: i))
        }
        return textures
    }
}
