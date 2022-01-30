import SpriteKit

class CollectorNode: SKSpriteNode {

    private var points: Int
    private var target: SKSpriteNode
    private var scoreLabel: SKLabelNode

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        points = 0
        target = SKSpriteNode(imageNamed: "collector")
        target = SKSpriteNode(imageNamed: "collector")
        target.anchorPoint = CGPoint(x: 1, y: 1)

        scoreLabel = SKLabelNode(fontNamed: "Courier-Bold")
        scoreLabel.text = "\(points)"
        scoreLabel.position = CGPoint(x: -target.frame.width - 10, y: -scoreLabel.frame.height / 2);
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 20

        super.init(texture: texture, color: color, size: size)

        addChild(target)
        addChild(scoreLabel)

        physicsBody = SKPhysicsBody(rectangleOf: calculateAccumulatedFrame().size)
        physicsBody?.categoryBitMask = SpriteCategory.collector.rawValue
        physicsBody?.affectedByGravity = false
        physicsBody?.contactTestBitMask = SpriteCategory.coin.rawValue
        name = "collector"
        physicsBody?.isDynamic = false
    }

    convenience init() {
        self.init(texture: nil, color: .clear, size: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addPoint() {
        self.points += 1
        self.scoreLabel.text = "\(points)"
    }
}
