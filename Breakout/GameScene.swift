//
//  GameScene.swift
//  Breakout
//
//  Created by MRisser1 on 3/13/17.
//  Copyright © 2017 MRisser1. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKSpriteNode()
    var paddle = SKSpriteNode()
    var brick = SKSpriteNode()
    var loseZone = SKSpriteNode()
    var playLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var livesLabel = SKLabelNode()
    var score = 0
    var lives = 3
    var gameIsRunning = false
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
        
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        self.physicsBody = border
        
        self.physicsWorld.contactDelegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
        gameIsRunning = true
        playLabel.text = ""
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "brick" || contact.bodyB.node?.name == "brick" {
            playLabel.text = "Congratulations! Tap to Play Again."
            resetGame()
        }
        if contact.bodyA.node?.name == "loseZone" || contact.bodyB.node?.name == "loseZone" {
            playLabel.text = "Game Over! Tap to Play Agaian."
            resetGame()
        }
    }
    
    func resetGame() {
        ball.removeFromParent()
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        paddle.removeFromParent()
        paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
        gameIsRunning = false
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1 {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.position = CGPoint(x: 0, y: starsBackground.size.height * CGFloat(i))
            addChild(starsBackground)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
    }
    
    func makeBall() {
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.name = "ball"
        // physics shape matches ball image
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ignores all forces and impulses
        ball.physicsBody?.isDynamic = false
        // use precise collision detection
        ball.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        ball.physicsBody?.friction = 0
        //gravity is not a factor
        ball.physicsBody?.affectedByGravity = false
        // bounces fully off of other objects
        ball.physicsBody?.restitution = 1
        // does not slow down over time
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        addChild(ball)
    }
    
    func makePaddle() {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width/4, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY+125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    
    func makeBrick() {
        brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: frame.width/5, height: 50))
        brick.position = CGPoint(x: frame.midX, y: frame.maxY-30)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
    }
    
    func makeLoseZone() {
        let loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY+25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    func makeLabels() {
        playLabel.fontSize = 30
        playLabel.fontName = "Arial"
        playLabel.text = "Welcome to Breakout. Tap to Begin"
        playLabel.name = "Start"
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        addChild(playLabel)
        
        scoreLabel.fontName = "Arial"
        scoreLabel.fontSize = 24
        scoreLabel.text = "Score: " + String(score)
        scoreLabel.name = "Scoreboard"
        scoreLabel.position = CGPoint(x: frame.minX+scoreLabel.frame.width, y: frame.minY+25)
        addChild(scoreLabel)
        
        livesLabel.fontSize = 24
        livesLabel.fontName = "Arial"
        livesLabel.text = "Lives: " + String(lives)
        livesLabel.name = "Live Display"
        livesLabel.position = CGPoint(x: frame.maxX-livesLabel.frame.width, y: frame.minY+25)
        addChild(livesLabel)
    }
    
}
