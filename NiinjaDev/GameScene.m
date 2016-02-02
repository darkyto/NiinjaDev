//
//  GameScene.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/29/16.
//  Copyright (c) 2016 iNick Iliev. All rights reserved.
//

#import "GameScene.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#import "NIHero.h"
#import "NIWorldGenerator.h"
#import "NIPointsLabel.h"
#import "NIScoreMenuImage.h"

@interface GameScene()<UIGestureRecognizerDelegate> {
    UISwipeGestureRecognizer *gestureRecognizerSwipeDown;
    UISwipeGestureRecognizer *gestureRecognizerSwipeUp;
    UITapGestureRecognizer *gestureRecognizerDoubleTap;
}

@property BOOL isStarted;
@property BOOL isGameOver;
@property BOOL isHeroSmaller;

@end

@implementation GameScene{
    
    NIHero *hero;
    SKNode *world;
    SKSpriteNode *ground;
    NIWorldGenerator *generator;
    
    NIPointsLabel *pointsLabel;
    NIScoreMenuImage *pointsImage;
    
    NIPointsLabel *firePointsLabel;
    NIScoreMenuImage *fireImage;

    NIScoreMenuImage *lifesRemainingImage;
}

static NSString *GAME_FONT = @"Chalkduster";

int _heroLifes = 4;
int _initialHeroFails = 0;
double _changeDirectionCriticalPoint;

//-(id)initWithSize:(CGSize)size {
//    if (self = [super initWithSize:size]) {
//        
//        self.anchorPoint = CGPointMake(0.5, 0.5);
//        
//        // to call the method that handles contacts within two bodies
//        self.physicsWorld.contactDelegate = self;
//        
//        [self createContent];
//    }
//    
//    return self;
//}

-(instancetype)initWithSize:(CGSize)size andUserChoiceHero:(NSString *)userChoiceHero {
    if (self = [super initWithSize:size]) {
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        // to call the method that handles contacts within two bodies
        self.physicsWorld.contactDelegate = self;
        
        if ([userChoiceHero  isEqual: @"greenman"]) {
            [self createContent : @"greenman"];
        } else if ([userChoiceHero isEqualToString:@"ninja"]) {
            [self createContent : @"ninja"];
        }

    }
    
    return self;
}

+(id)initWithSize:(CGSize)size andUserChoiceHero:(NSString *)userChoiceHero {
    return [[GameScene alloc] initWithSize:size
                         andUserChoiceHero:userChoiceHero];
}

-(void)didMoveToView:(SKView *)view {
    
    gestureRecognizerSwipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandlerDown:)];
    [gestureRecognizerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [view addGestureRecognizer:gestureRecognizerSwipeDown];
    
    gestureRecognizerSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerUp:)];
    [gestureRecognizerSwipeUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [view addGestureRecognizer:gestureRecognizerSwipeUp];

    gestureRecognizerDoubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTap:)];
    [gestureRecognizerDoubleTap setNumberOfTapsRequired:2];
    [view addGestureRecognizer:gestureRecognizerDoubleTap];
    
    _changeDirectionCriticalPoint = self.frame.size.height/6;
}

-(void)willMoveFromView:(SKView *)view {
    [self.view removeGestureRecognizer: gestureRecognizerSwipeDown];
    [self.view removeGestureRecognizer: gestureRecognizerSwipeUp];
}

-(void)swipeHandlerDown:(UISwipeGestureRecognizer *)recognizer {
    [hero makeHeroSmaller];
    self.isHeroSmaller = NO;
    
}

-(void)swipeHandlerUp:(UISwipeGestureRecognizer *)recognizer {
    [hero makeHeroLarger];
    self.isHeroSmaller = YES;
    
}

-(void)tapTap:(UITapGestureRecognizer *)recognizer {
    CGPoint tapPoint = [recognizer locationInView:self.view];

    if (tapPoint.x <= _changeDirectionCriticalPoint) {
        [hero jumpLeft];
    } else if (tapPoint.x > _changeDirectionCriticalPoint)  {
        [hero jumpRight];
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    if (_heroLifes > _initialHeroFails) {
        _initialHeroFails++;
        NSString *lifeImageString = [NSString stringWithFormat:@"Life-%i", _initialHeroFails];
        NIScoreMenuImage *lifeBurned = (NIScoreMenuImage *) [self childNodeWithName:lifeImageString];
        [lifeBurned removeFromParent];
        
        SKLabelNode *fireBurnMessage = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
        fireBurnMessage.position = CGPointMake(hero.position.x + hero.frame.size.width/3,
                                                      hero.position.y + hero.frame.size.height/2);
        fireBurnMessage.text = @"Ouch! It burns!";
        fireBurnMessage.fontSize = 14;
        fireBurnMessage.fontColor = [UIColor redColor];
        fireBurnMessage.name = @"fireBurnMessage";
        [world addChild:fireBurnMessage];
        [self animateWithScale:fireBurnMessage];
        
        // this can reset hero ot its inital level position after each fail - too user unfriendly!?
//        [hero removeFromParent];
//        hero = [NIHero hero];
//        [world addChild:hero];
    }

    if (_initialHeroFails >= _heroLifes) {
        SKLabelNode *fireBurnMessage = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
        fireBurnMessage.position = CGPointMake(hero.position.x + hero.frame.size.width/3,
                                               hero.position.y + hero.frame.size.height/2);
        fireBurnMessage.text = @"I'll be back!!!";
        fireBurnMessage.fontSize = 14;
        fireBurnMessage.fontColor = [UIColor redColor];
        fireBurnMessage.name = @"fireBurnMessage";
        [world addChild:fireBurnMessage];
        [self animateWithScale:fireBurnMessage];
        
        [self gameOver];
    }
}

-(void)createContent:(NSString *) userChoiceHero {
    self.backgroundColor = [SKColor brownColor];
    
    world = [SKNode node];
    [self addChild:world];
    
    generator = [NIWorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    
    hero = [NIHero hero:userChoiceHero];
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
    
    // TODO: OK now add a special RUNE to add extra-life
    for (int i = 1; i <= _heroLifes; i++) {
        lifesRemainingImage = [NIScoreMenuImage scoreMenuImageWithNamedImage:@"red-greenman-1-0"];
        lifesRemainingImage.position = CGPointMake(i * 20, 90);
        lifesRemainingImage.xScale = 0.2;
        lifesRemainingImage.yScale = 0.2;
        lifesRemainingImage.name = [NSString stringWithFormat:@"Life-%i", i];
        [self addChild:lifesRemainingImage];
    }
    
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

    GameScene *scene = [GameScene initWithSize:CGSizeMake(self.view.frame.size.height, self.view.frame.size.width) andUserChoiceHero:@"greenman"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.view presentScene:scene];
}

-(void)gameOver {
    self.isGameOver = YES;
    [hero stop];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontSize = 20;
    gameOverLabel.position = CGPointMake(0, 50);
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

-(void) centerOfNode:(SKNode *) node {
    CGPoint positionInTheScne = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x - positionInTheScne.x - _changeDirectionCriticalPoint,
                                 world.position.y - positionInTheScne.y - self.frame.size.width/10);
    
    // - positionInTheScne.y (delete it to remove screen dynamic movement by y)
}

-(void) handlePoints {
    
    [world enumerateChildNodesWithName:@"fireObstacle" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x < hero.position.x) {
            firePointsLabel = (NIPointsLabel *)[self childNodeWithName:@"firePointsLabel"];
            [firePointsLabel increment];
        }
    }];
    
    
    [world enumerateChildNodesWithName:@"pointsBonusRune" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if ( (node.position.x < hero.position.x) &
            (node.position.y >= hero.position.y - 20 & node.position.y <= hero.position.y + 20) )  {
            pointsLabel = (NIPointsLabel *)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
            
            SKLabelNode *pointsCollectedMessage = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
            pointsCollectedMessage.position = CGPointMake(node.position.x + hero.frame.size.width/3,
                                                          node.position.y + hero.frame.size.height/2);
            pointsCollectedMessage.text = @"My Precious!";
            pointsCollectedMessage.fontSize = 14;
            pointsCollectedMessage.fontColor = [UIColor redColor];
            pointsCollectedMessage.name = @"pointsCollectedMessage";
            [world addChild:pointsCollectedMessage];
            [self animateWithScale:pointsCollectedMessage];

        }
    }];
}

-(void) handleGeneration {
    
 [world enumerateChildNodesWithName:@"fireObstacle" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
     if (node.position.x < hero.position.x) {
         node.name = @"fireObstacleCanceled";
     }
 }];
    
 [world enumerateChildNodesWithName:@"pointsBonusRune" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
    if (node.position.x < hero.position.x + 100) {
        node.name = @"pointsBonusRuneCanceled";
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
        if ( (node.position.x <= hero.position.x) &
            (node.position.y >= hero.position.y - 20 & node.position.y <= hero.position.y + 20) ) {
            [node removeFromParent];
        }
    }];
    
    [world enumerateChildNodesWithName:@"background" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x + node.frame.size.width < hero.position.x - self.frame.size.height/2 + node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
    
    [world enumerateChildNodesWithName:@"pointsCollectedMessage" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if ( node.position.x <= hero.position.x - 250) {
            [node removeFromParent];
        }
    }];
    
    [world enumerateChildNodesWithName:@"fireBurnMessage" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if ( node.position.x <= hero.position.x - 50) {
            [node removeFromParent];
        }
    }];
    

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isStarted) {
        [self start];
    } else if (self.isGameOver) {
        [self clear];
        _initialHeroFails = 0;
        
    }
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    if (location.x <= _changeDirectionCriticalPoint) {
        [hero walkLeft];
    } else if (location.x > _changeDirectionCriticalPoint) {
        [hero walkRight];
    }
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

-(void) animateWithScale:(SKNode *)node {

    SKAction *scaleTo = [SKAction scaleTo:0 duration:1];
    SKAction *scaleFrom = [SKAction scaleTo:1 duration:1];
    SKAction *scale = [SKAction sequence:@[scaleFrom, scaleTo]];
    
    [node runAction:scale];
}

@end
