import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate{
    weak var hero: CCSprite!
    weak var gamePhysicsNode : CCPhysicsNode!
    
    weak var obstaclesLayer : CCNode!
    weak var restartButton : CCButton!
    
    weak var scoreLabel : CCLabelTTF!
    
    weak var ground1 : CCSprite!
    weak var ground2 : CCSprite!
    var grounds = [CCSprite]()
    
    var sinceTouch : CCTime = 0
    var scrollSpeed : CGFloat = 80
    
    var obstacles : [CCNode] = []
    let firstObstaclePosition : CGFloat = 280
    let distanceBetweenObstacles : CGFloat = 160
    
    var gameOver = false
    
    var points : NSInteger = 0
    
    
    
    func triggerGameOver(){
        if(gameOver == false) {
            gameOver = true
            restartButton.visible = true
            scrollSpeed = 0
            hero.rotation = 90
            hero.physicsBody.allowsRotation = false
            hero.stopAllActions()
            
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 4)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
    
    func spawnNewObstacle() {
        var prevObstaclePos = firstObstaclePosition
        if obstacles.count > 0 {
            prevObstaclePos = obstacles.last!.position.x
        }
        
        let obstacle = CCBReader.load("Obstacle") as! Obstacle
        obstacle.position = ccp(prevObstaclePos + distanceBetweenObstacles, 0)
        obstacle.setupRandomPosition()
        obstaclesLayer.addChild(obstacle)
        obstacles.append(obstacle)
    }
    
    //충돌체크
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, level: CCNode!) -> Bool {
        triggerGameOver()
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, goal: CCNode!) -> Bool {
        goal.removeFromParent()
        points += 1
        scoreLabel.string = String(points)
        return true
    }
    
    func restart(){
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        grounds.append(ground1)
        grounds.append(ground2)
        
        for _ in 0...2 {
            spawnNewObstacle()
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!){
        
        if (gameOver == false) {
            hero.physicsBody.applyImpulse(ccp(0, 400));
            hero.physicsBody.applyAngularImpulse(10000)
            sinceTouch = 0
        }
    }
    
    override func update(delta: CCTime){
        let velocityY = clampf(Float(hero.physicsBody.velocity.y), -Float(CGFloat.max), 200)
        hero.physicsBody.velocity = ccp(0, CGFloat(velocityY))
        
        sinceTouch += delta
        
        hero.rotation = clampf(hero.rotation, -30, 90)
        if(hero.physicsBody.allowsRotation){
            let angularVelocity = clampf(Float(hero.physicsBody.angularVelocity),-2,1)
            hero.physicsBody.angularVelocity = CGFloat(angularVelocity)
        }
        if(sinceTouch > 0.3) {
            let impuse = -18000.0 * delta
            hero.physicsBody.applyAngularImpulse(CGFloat(impuse))
        }
        
        hero.position = ccp(hero.position.x + scrollSpeed * CGFloat(delta), hero.position.y)
        gamePhysicsNode.position = ccp(gamePhysicsNode.position.x - scrollSpeed * CGFloat(delta), gamePhysicsNode.position.y)
        
        for ground in grounds {
            let groundWorldPosition = gamePhysicsNode.convertToWorldSpace(ground.position)
            let groundScreenPosition = convertToNodeSpace(groundWorldPosition)
            if groundScreenPosition.x <= (-ground.contentSize.width){
                ground.position = ccp(ground.position.x + ground.contentSize.width * 2, ground.position.y)
            }
        }
        
        for obstacle in Array(obstacles.reverse()) {
            let obstacleWorldPosition = gamePhysicsNode.convertToWorldSpace(obstacle.position)
            let obstacleScreenPosition = convertToNodeSpace(obstacleWorldPosition)
            
            if obstacleScreenPosition.x < (-obstacle.contentSize.width){
                obstacle.removeFromParent()
                obstacles.removeAtIndex(obstacles.indexOf(obstacle)!)
                
                spawnNewObstacle()
            }
        }
    }

}
