//
//  GameScene.swift
//  Galactiverse
//
//  Created by Jake Garcia on 9/26/18.
//  Copyright © 2018 Jake Garcia. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum InvaderType {
        case a
        case b
        case c
        static var size: CGSize {
            return CGSize(width: 24, height: 16)
        }
        
        static var name: String {
            return "invader"
        }
    }
    
    let kInvaderGridSpacing = CGSize(width: 20, height: 20)
    let kInvaderRowCount = 9
    let kInvaderColCount = 9
    let kShipSize = CGSize(width: 40, height: 24)
    let kShipName = "ship"
    
    
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    var starField:SKEmitterNode!
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0, y: 0)
        createBackground()
        // createPlayer()
        setupShip()
        placeScoreLabel()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        setupInvader()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastTouchPosition = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            lastTouchPosition = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    // Create the player, node, and collision bit mask
//    func createPlayer() {
//        player = SKSpriteNode(imageNamed: "ship")
//        player.position = CGPoint(x: frame.size.width/2, y: player.size.height/2 + 20)
//        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
//        player.physicsBody?.allowsRotation = false
//        player.physicsBody?.linearDamping = 0.5
//
//        addChild(player)
//    }
    // Create the background by using an SKEmitterNode
    func createBackground() {
        
        starField = SKEmitterNode(fileNamed: "starfield")
        starField.position = CGPoint(x: frame.size.width/2, y: frame.size.height)
        starField.advanceSimulationTime(10)
        starField.zPosition = -1
        self.addChild(starField)
    }
    // Place the score label in the top left corner of any screen
    func placeScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: self.frame.size.width/10, y: self.frame.size.height - 60)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.fontName = "sans-serif"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        self.addChild(scoreLabel)
    }
    
    //Add enemy aliens
    func addAlien(ofType invaderType: InvaderType) -> SKNode {
        var invaderColor: SKColor
        switch(invaderType) {
        case .a:
            invaderColor = SKColor.red
        case .b:
            invaderColor = SKColor.green
        case .c:
            invaderColor = SKColor.blue
        }
        let invader = SKSpriteNode(color: invaderColor, size: InvaderType.size)
        invader.name = InvaderType.name
        return invader
    }
    
    func setupInvader() {
        let baseOrigin = CGPoint(x: size.width / 3, y: size.height / 2)
        
        for row in 0..<kInvaderRowCount {
            var invaderType: InvaderType
            if row % 3 == 0 {
                invaderType = .a
            } else if row % 3 == 1 {
                invaderType = .b
            } else {
                invaderType = .c
            }
            
            let invaderPositionY = CGFloat(row) * (InvaderType.size.height * 2) + baseOrigin.y
            var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
            
            for _ in 1..<kInvaderColCount {
                let invader = addAlien(ofType: invaderType)
                invader.position = invaderPosition
                
                addChild(invader)
                
                invaderPosition = CGPoint(
                    x: invaderPosition.x + InvaderType.size.width + kInvaderGridSpacing.width,
                    y: invaderPositionY
                )
            }
        }
    }
    
    // Create and setuo ship
    func setupShip() {
        let ship = makeShip()
        
        ship.position = CGPoint(x: size.width / 2.0, y: (kShipSize.height / 2.0) + 20)
        addChild(ship)
    }
    
    func makeShip() -> SKNode {
        let ship = SKSpriteNode(color: SKColor.green, size: kShipSize)
        ship.name = kShipName
        return ship
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 15, dy: 0)
        }
    }
    
}
