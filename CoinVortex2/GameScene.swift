//
//  GameScene.swift
//  CoinVortex2
//
//  Created by Andrew Erickson on 2022-01-29.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private let collector: CollectorNode

    override init(size: CGSize) {
        collector = CollectorNode()
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        setupWorld()

        let topRight = CGPoint(x: frame.size.width / 2 - 10, y: frame.size.height / 2 - 10)

        addFieldNode(at: topRight)
        addCollector(at: topRight)
        showFirstHelpMessage()
    }

    private func setupWorld() {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self

        let bounds = SKNode()
        bounds.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        bounds.physicsBody?.categoryBitMask = SpriteCategory.bounds.rawValue
        bounds.physicsBody?.collisionBitMask = SpriteCategory.coin.rawValue

        addChild(bounds)
    }

    private func addFieldNode(at position: CGPoint) {
        let fieldNode = SKFieldNode.radialGravityField()
        fieldNode.isEnabled = true
        fieldNode.categoryBitMask = SpriteCategory.gravityField.rawValue
        fieldNode.strength = 40
        fieldNode.falloff = 1.1 // Objects move slightly faster as they become closer to the field
        fieldNode.position = position

        addChild(fieldNode)
    }

    private func addCollector(at position: CGPoint) {
        collector.anchorPoint = CGPoint(x: 1, y: 1)
        collector.position = position

        addChild(collector)
    }

    private func addCoinEmitter() {
        let coinEmitter = CoinEmitterNode()
        coinEmitter.anchorPoint = CGPoint(x: 0.5, y: 0)
        coinEmitter.position = CGPoint(x: 0, y: -frame.height / 2 + 20)

        addChild(coinEmitter)

        let waitOneSecond = SKAction.wait(forDuration: 1)
        let releaseCoinAction = SKAction.perform(#selector(CoinEmitterNode.releaseCoin), onTarget: coinEmitter)
        let releaseCoinSequence = SKAction.sequence([waitOneSecond, releaseCoinAction])
        run(SKAction.repeatForever(releaseCoinSequence))
    }

    private func showFirstHelpMessage() {
        let explainLabel = SKLabelNode(fontNamed: "Helvetica")
        explainLabel.fontSize = 16
        explainLabel.text = "Coins are released from the bottom of the screen every second"
        addChild(explainLabel)

        let bottomPosition = CGPoint(x: 0, y: -frame.height / 2 + explainLabel.fontSize)
        let moveToBottom = SKAction.move(to: bottomPosition, duration: 1)

        explainLabel.run(moveToBottom) {
            self.clear(label: explainLabel, after: 3) {
                self.showSecondHelpMessage()
            }
        }
    }

    func showSecondHelpMessage() {
        let helpLabel = SKLabelNode(fontNamed: "Helvetica")
        helpLabel.fontSize = 16
        helpLabel.text = "Tap the screen to collect even more coins!"
        addChild(helpLabel)

        clear(label: helpLabel, after: 3) {
            self.addCoinEmitter()
        }
    }

    func clear(label: SKLabelNode, after waitDuration: TimeInterval, completion: @escaping () -> Void) {
        let wait = SKAction.wait(forDuration: waitDuration)
        let fadeOut = SKAction.scale(by: 0, duration: 0.5)
        let fadeOutSequence = SKAction.sequence([wait, fadeOut])
        label.run(fadeOutSequence, completion: completion)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            createCoin(at: touch.location(in: self))
        }
    }

    func createCoin(at position: CGPoint) {
        let coin = CoinNode()
        coin.position = position
        addChild(coin)
    }
}

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        var coin: CoinNode?

        if contact.bodyA.node?.name == "coin" && contact.bodyB.node?.name == "collector" {
            coin = contact.bodyA.node as? CoinNode
        } else if contact.bodyB.node?.name == "coin" && contact.bodyA.node?.name == "collector" {
            coin = contact.bodyB.node as? CoinNode
        }

        guard let coin = coin else { return }

        coin.removeFromParent()
        collector.addPoint()
    }
}

enum SpriteCategory: UInt32 {
    case all
    case gravityField
    case coin
    case collector
    case bounds
}
