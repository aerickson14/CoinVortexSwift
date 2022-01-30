import SpriteKit

class CoinEmitterNode: SKSpriteNode {

    @objc
    func releaseCoin() {
        let coin = CoinNode()

        coin.alpha = 0
        coin.position = position
        coin.physicsBody?.isDynamic = false
        parent?.addChild(coin)

        let fadeIn = SKAction.fadeIn(withDuration: 0)
        let blinkIn = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0.2)
        let blinkOut = SKAction.colorize(with: .white, colorBlendFactor: 0, duration: 0.2)
        let startSequence = SKAction.sequence([fadeIn, blinkIn, blinkOut])

        coin.run(startSequence) {
            coin.physicsBody?.isDynamic = true
            var dx = CGFloat(arc4random_uniform(5))
            dx = dx - 2 // do this after to prevent overflow of the unsigned int
            let dy = CGFloat(arc4random_uniform(3))

            let impuseVector = CGVector(dx: dx, dy: dy)
            coin.physicsBody?.applyImpulse(impuseVector)
        }
    }
}
