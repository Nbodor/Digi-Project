import Foundation
import SpriteKit



class SpriteSheet {
    let name: String
    let rows: Int
    let cols: Int
    let frameSize: CGSize
    let sheet: SKTexture
    
    init(imageNamed name: String, rows: Int, cols: Int) {
        self.name = name
        self.rows = rows
        self.cols = cols
        self.frameSize = CGSize(width: 1.0 / CGFloat(cols), height: 1.0 / CGFloat(rows))
        self.sheet = SKTexture(imageNamed: name)
    }
    
    func toAtlas() -> SKTextureAtlas {
        var textures = Dictionary<String, CGImage>()
        for row in 0...rows {
            for col in 0...cols {
                let x = CGFloat(col) / CGFloat(cols)
                let y = CGFloat(row) / CGFloat(rows)
                let subtextureRect = CGRect(origin: CGPoint(x: x, y: y), size: frameSize)
                let subtexture = SKTexture(rect: subtextureRect, in: sheet)
                textures["\(name)_\(row)_\(col)"] = subtexture.cgImage()
            }
        }
        return SKTextureAtlas(dictionary: textures)
    }
    
    
    func texture(row: Int, col: Int) -> SKTexture {
        let x = CGFloat(col) / CGFloat(cols)
        let y = CGFloat(row) / CGFloat(rows)
        let subtextureRect = CGRect(origin: CGPoint(x: x, y: y), size: frameSize)
        return SKTexture(rect: subtextureRect, in: sheet)
    }
}
