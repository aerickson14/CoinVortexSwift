import SpriteKit

class CoinNode: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "coin")
        super.init(texture: texture, color: .clear, size: texture.size())

        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.fieldBitMask = SpriteCategory.gravityField.rawValue
        physicsBody?.categoryBitMask = SpriteCategory.coin.rawValue
        physicsBody?.collisionBitMask = SpriteCategory.bounds.rawValue
        physicsBody?.contactTestBitMask = SpriteCategory.collector.rawValue

        name = "coin"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
