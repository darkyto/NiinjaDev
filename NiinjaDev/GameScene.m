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
#import "NIScoreMenuImage.h"

@interface GameScene()

@property BOOL isStarted;
@property BOOL isGameOver;

@end

@implementation GameScene {
    NIHero *hero;
    SKNode *world;
    SKSpriteNode *ground;
    NIPointsLabel *pointsLabel;
    NIScoreMenuImage *pointsImage;
    NIScoreMenuImage *firePointsLabel;
    NIScoreMenuImage *fireImage;
    NIWorldGenerator *generator;
    NIScoreMenuImage *lifesRemainingImage;
}

static NSString *GAME_FONT = @"Chalkduster";

static int HERO_LIFES = 3;

int _actionDirectionCriticalPoint = 200;
int _heroAligment = 100;
int _initialHeroFails = 0;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        // to call the method that handles contacts  within two bodies
        self.physicsWorld.contactDelegate = self;
        
        [self createContent];
        
        // available fonts listed in xcode output
//        for (id familyName in [UIFont familyNames]) {
//            NSLog(@"%@", familyName);
//            for (id fontName in [UIFont fontNamesForFamilyName:familyName]) NSLog(@"  %@", fontName);
//        }
    }
    
    return self;
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if (HERO_LIFES >= _initialHeroFails) {
        _initialHeroFails++;
        NSString *lifeImageString = [NSString stringWithFormat:@"Life-%i", _initialHeroFails];
        NIScoreMenuImage *lifeBurned = (NIScoreMenuImage *) [self childNodeWithName:lifeImageString];
        [lifeBurned removeFromParent];
        
        // this can reset hero ot its inital position after each fail
//        [hero removeFromParent];
//        hero = [NIHero hero];
//        [world addChild:hero];
        

    }

    if (_initialHeroFails >= HERO_LIFES) {
        // All Lifes burned
        [self gameOver];
    }
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
    pointsLabel.position = CGPointMake(140, 80);
    pointsLabel.name = @"pointsLabel";
    [self addChild:pointsLabel];
    
    pointsImage = [NIScoreMenuImage scoreMenuImageWithNamedImage:@"7_gf_set_3"];
    pointsImage.position = CGPointMake(170, 90);
    pointsImage.xScale = 0.2;
    pointsImage.yScale = 0.2;
    [self addChild:pointsImage];
    
    firePointsLabel = [NIPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    firePointsLabel.position = CGPointMake(140, 60);
    firePointsLabel.name = @"firePointsLabel";
    [self addChild:firePointsLabel];
    
    fireImage = [NIScoreMenuImage scoreMenuImageWithNamedImage:@"Fire-1"];
    fireImage.position = CGPointMake(170, 70);
    fireImage.xScale = 0.3;
    fireImage.yScale = 0.3;
    [self addChild:fireImage];
    
    lifesRemainingImage = [NIScoreMenuImage scoreMenuImageWithNamedImage:@"greenman-1-0"];
    lifesRemainingImage.position = CGPointMake(10, 90);
    lifesRemainingImage.xScale = 0.2;
    lifesRemainingImage.yScale = 0.2;
    lifesRemainingImage.name = @"Life-1";
    [self addChild:lifesRemainingImage];
    
    lifesRemainingImage = [NIScoreMenuImage scoreMenuImageWithNamedImage:@"greenman-1-0"];
    lifesRemainingImage.position = CGPointMake(30, 90);
    lifesRemainingImage.xScale = 0.2;
    lifesRemainingImage.yScale = 0.2;
    lifesRemainingImage.name = @"Life-2";
    [self addChild:lifesRemainingImage];
    
    lifesRemainingImage = [NIScoreMenuImage scoreMenuImageWithNamedImage:@"greenman-1-0"];
    lifesRemainingImage.position = CGPointMake(50, 90);
    lifesRemainingImage.xScale = 0.2;
    lifesRemainingImage.yScale = 0.2;
    lifesRemainingImage.name = @"Life-3";
    [self addChild:lifesRemainingImage];
    
    SKLabelNode *tapToBeginLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToBeginLabel.text = @"Tap to Start!";
    tapToBeginLabel.fontSize = 20;
    tapToBeginLabel.name = @"tapToBeginLabel";
    [self addChild:tapToBeginLabel];
    
    [self animateWithPulse:tapToBeginLabel];
    
}

-(void)start {
    self.isStarted = YES;
    [[self childNodeWithName:@"tapToBeginLabel"] removeFromParent];
    [hero start];
}

-(void)clear {
    // MARK: Maybe this will lead to current score and an option to RESTART from there !?
    GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:scene];
}

-(void)gameOver {
    self.isGameOver = YES;
    [hero stop];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontSize = 20;
    gameOverLabel.position = CGPointMake(0, 50);
    //NSLog(@"gameOver is called");
    [self addChild:gameOverLabel];
    
    SKLabelNode *tapToRestLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToRestLabel.text = @"Tap to Restart Level!";
    tapToRestLabel.fontSize = 20;
    tapToRestLabel.name = @"tapToRestLabel";
    [self addChild:tapToRestLabel];
    
    [self animateWithPulse:tapToRestLabel];
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
            pointsLabel = (NIPointsLabel *)[self childNodeWithName:@"firePointsLabel"];
            [pointsLabel increment];
        }
    }];
    
    
    
    [world enumerateChildNodesWithName:@"pointsBonusRune" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
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
    
    [world enumerateChildNodesWithName:@"pointsBonusRune" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x < hero.position.x) {
            node.name = @"pointsBonusRuneCanceled";
            NSLog(@"RUNE marked for cancelation!");
        }
    }];
    
}

-(void) handleCleanup {
    
    // This method removes all objects that are left behind our hero...
    // CAUTION: I will have to remove it if the hero will be reurning back in the scene...
    // for example if i made level to go upstaris i do not want to clean whats behind...
    
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
    
    [world enumerateChildNodesWithName:@"pointsBonusRuneCanceled" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x < hero.position.x) {
            [node removeFromParent];
        }
    }];
    
    [world enumerateChildNodesWithName:@"background" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x + node.frame.size.width < hero.position.x - self.frame.size.height/2 + node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
}

-(void) centerOfNode:(SKNode *) node {
    CGPoint positionInTheScne = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x - positionInTheScne.x - _heroAligment, world.position.y);
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void) animateWithPulse:(SKNode *)node {
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:1];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:1];
    
    SKAction *scaleTo = [SKAction scaleTo:0.7 duration:1];
    SKAction *scaleFrom = [SKAction scaleTo:1 duration:1];
    
    SKAction *pulse = [SKAction sequence:@[disappear, appear]];
    SKAction *scale = [SKAction sequence:@[scaleTo, scaleFrom]];
    
    [node runAction:[SKAction repeatActionForever:pulse]];
    [node runAction:[SKAction repeatActionForever:scale]];
}

@end
