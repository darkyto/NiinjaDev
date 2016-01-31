//
//  GameScene.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/29/16.
//  Copyright (c) 2016 iNick Iliev. All rights reserved.
//

#import "GameScene.h"
#import "NIHero.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "NIWorldGenerator.h"
#import "NIPointsLabel.h"
#import "NIPointsImage.h"

@interface GameScene()

@property BOOL isStarted;
@property BOOL isGameOver;

@end

@implementation GameScene {
    NIHero *hero;
    SKNode *world;
    SKSpriteNode *ground;
    NIPointsLabel *pointsLabel;
    NIPointsImage * pointsImage;
    NIWorldGenerator *generator;
}

static NSString *GAME_FONT = @"Bodoni 72 Oldstyle";

NSTimeInterval _lastUpdateTime;
NSTimeInterval _dt;
CGPoint _velocity;
CGPoint _currentPosition;
int _actionDirectionCriticalPoint = 200;
int _heroAligment = 100;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        // to call the method for collides within two bodis
        self.physicsWorld.contactDelegate = self;
        
        
        [self createContent];
    }
    
    return self;
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    [self gameOver];
}

-(void)createContent {
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:0.9];
    
    world = [SKNode node];
    [self addChild:world];
    
    generator = [NIWorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    
    hero = [NIHero hero];
    [world addChild:hero];
    
    pointsLabel = [NIPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    pointsLabel.position = CGPointMake(150, 85);
    [self addChild:pointsLabel];
    
    pointsImage = [NIPointsImage pointsImageWithNamedImage:@"7_gf_set_3"];
    pointsImage.position = CGPointMake(170, 90);
    [self addChild:pointsImage];
}

-(void)start {
    self.isStarted = YES;
    [hero start];
}

-(void)clear {
    // MARK: Maybe this will lead to current score and an option to RESTART from there !?
    GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:scene];
}

-(void)gameOver {
    // MARK: initiate the gameOver logic here
    self.isGameOver = YES;
    [hero stop];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameOverLabel.text = @"Game Over";
    gameOverLabel.position = CGPointMake(0, 50);
    //NSLog(@"gameOver is called");
    [self addChild:gameOverLabel];
}

-(void)didSimulatePhysics {
    [self centerOfNode:hero];
    
    [self handlePoints];
    
    [self handleGeneration];
    
    [self handleCleanup];

}

-(void) handlePoints {
    
    // MARK: Add the bonus artefacts and collect points through them
    [world enumerateChildNodesWithName:@"fireObstacle" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x < hero.position.x) {
            pointsLabel = (NIPointsLabel *)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
        }
    }];
}

-(void) handleGeneration {
    
 [world enumerateChildNodesWithName:@"fireObstacle" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
     if (node.position.x < hero.position.x) {
         node.name = @"fireObstacleCanceled";
        // [generator generate]; // i am calling this in NIWorldGenerator so.. fix the ground/obstacles and then call here
        // NSLog(@"HERE obstacle marked for cancelation!");
     }
 }];
    
}

-(void) handleCleanup {
    // This method removes all objects that are left behind our hero...
    // I will have to remove it if the hero will be reurning back in the scene...
    
    [world enumerateChildNodesWithName:@"back" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x < hero.position.x - self.frame.size.height/2 + node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
    
    [world enumerateChildNodesWithName:@"fireObstacleCanceled" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x < hero.position.x - self.frame.size.height/2 + node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
//    
//    [world enumerateChildNodesWithName:@"background" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
//        if (node.position.x < hero.position.x - self.frame.size.height/2 + node.frame.size.width/2) {
//            [node removeFromParent];
//        }
//    }];
}

-(void) centerOfNode:(SKNode *) node {
    CGPoint positionInTheScne = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x - positionInTheScne.x - _heroAligment, world.position.y);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isStarted) {
        [self start];
    } else if (self.isGameOver) {
        [self clear];
    }
    
    // MARK : for testing - remove later
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    // MARK : Remove walkRight (mybe auto movement!?) and make better jump & speed
    for (UITouch *aTouch in touches) {
        if (aTouch.tapCount == 2) {
            if (location.x <= _actionDirectionCriticalPoint) {
                [hero jumpLeft];
            } else {
                [hero jumpRight];
            }
            return;
        }
        NSLog(@"HERO position X : %f", hero.position.x);
        NSLog(@"TAP position X : %f", location.x);
        NSLog(@"GROUND position X : %f", ground.position.x);
        NSLog(@"WORLD position X: %f", world.position.x);
        
        // NOT GOOD ENOUGH - Fix this to make hero move back when the tap is behind him
        // Fixed!? Test some more - test with fire object obstacle and add physics constraints
        if (location.x <= _actionDirectionCriticalPoint) {
            [hero walkLeft];
        } else {
            [hero walkRight];
        }

    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UITouch *aTouch in touches) {
//        if (aTouch.tapCount >= 2) {
//            [hero jump];
//            return;
//        }
//        [hero walkRight];
//    }
    
}

//-(void)update:(CFTimeInterval)currentTime {
//    if(_lastUpdateTime)
//    {
//        _dt = currentTime - _lastUpdateTime;
//    }
//    else
//    {
//        _dt=0;
//    }
//    _lastUpdateTime = currentTime;
//    [self moveGround];
//}
//
//-(void)moveGround
//{
//    [self enumerateChildNodesWithName:@"back" usingBlock:^(SKNode *node, BOOL *stop){
//        ground  = (SKSpriteNode *)node;
//        CGPoint bgVelocity = CGPointMake(-60.0, 0); //The speed at which the background image will move
//        CGPoint amountToMove = CGPointMultiplyScalar (bgVelocity,_dt);
//        ground.position = CGPointAdd(ground.position,amountToMove);
//        if (ground.position.x <= -ground.size.width *4)
//        {
//            ground.position = CGPointMake(ground.position.x + (ground.size.width)*2, ground.position.y);
//        }
//    }];
//    
//    [self enumerateChildNodesWithName:@"game-background-sprites-0" usingBlock:^(SKNode *node, BOOL *stop){
//        SKSpriteNode *background  = (SKSpriteNode *)node;
//        CGPoint bgVelocity = CGPointMake(-200.0, 0); //The speed at which the background image will move
//        CGPoint amountToMove = CGPointMultiplyScalar (bgVelocity,_dt);
//        background.position = CGPointAdd(background.position,amountToMove);
//        if (background.position.x <= -background.size.width *4)
//        {
//            background.position = CGPointMake(background.position.x + (background.size.width)*2,
//                                              background.position.y);
//        }
//    }];
//}
//
//CGPoint CGPointAdd(CGPoint p1, CGPoint p2)
//{
//    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
//}
//
//CGPoint CGPointMultiplyScalar(CGPoint p1, CGFloat p2)
//{
//    return CGPointMake(p1.x *p2, p1.y*p2);
//}

@end
