//
//  GameScene.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/29/16.
//  Copyright (c) 2016 iNick Iliev. All rights reserved.
//
#import <stdlib.h>
#import "GameScene.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#import "Answer.h"
#import "Question.h"
#import "Player.h"
#import "Score.h"

#import "NIGameData.h"

#import "NIHero.h"
#import "NIWorldGenerator.h"
#import "NIPointsLabel.h"
#import "NIScoreMenuImage.h"
#import "NIQuizButton.h"

#import "StartupViewController.h"

// #import "NiinjaDev-Bridging-Header.h"


@interface GameScene()<UIGestureRecognizerDelegate> {
    
    UISwipeGestureRecognizer *gestureRecognizerSwipeDown;
    UISwipeGestureRecognizer *gestureRecognizerSwipeUp;
    UITapGestureRecognizer *gestureRecognizerDoubleTap;
    
    UIView *quizView;
    UILabel *intro;
    UILabel *question;
    
    NIQuizButton *answerOne;
    NIQuizButton *answerTwo;
    NIQuizButton *answerThree;
    NIQuizButton *answerFour;
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
    
    NIPointsLabel *scoreLabel;
    NIPointsLabel *scoreLabelValue;
    
    NIPointsLabel *bestLabel;
    NIPointsLabel *bestLabelValue;
    
    NIPointsLabel *pointsLabel;
    NIScoreMenuImage *pointsImage;
    
    NIPointsLabel *blueRunesLabel;
    NIScoreMenuImage *blueRunesImage;
    
    NIPointsLabel *firePointsLabel;
    NIScoreMenuImage *fireImage;

    NIScoreMenuImage *lifesRemainingImage;
    
    NIGameData *gameData;
}

@synthesize fetchedResultsController, managedObjectContext;

@synthesize audioPlayer;

@synthesize players;
@synthesize playerScores;
@synthesize allAnswers;
@synthesize allQuestions;

static NSString *GAME_FONT = @"Chalkduster";

int _heroLifes = 4;
int _initialHeroFails = 0;
double _changeDirectionCriticalPoint;

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
        
        [self addLoopingMusicToBackground:@"/Lost-Jungle_Looping.mp3" ];
        //[audioPlayer play];
    }
    
    return self;
}

+(id)initWithSize:(CGSize)size andUserChoiceHero:(NSString *)userChoiceHero {
    return [[GameScene alloc] initWithSize:size
                         andUserChoiceHero:userChoiceHero];
}

-(void)didMoveToView:(SKView *)view {
    
    // swipe down
    gestureRecognizerSwipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandlerDown:)];
    [gestureRecognizerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [view addGestureRecognizer:gestureRecognizerSwipeDown];
    
    // swipe up
    gestureRecognizerSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerUp:)];
    [gestureRecognizerSwipeUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [view addGestureRecognizer:gestureRecognizerSwipeUp];

    // double touch
    gestureRecognizerDoubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTap:)];
    [gestureRecognizerDoubleTap setNumberOfTapsRequired:2];
    [view addGestureRecognizer:gestureRecognizerDoubleTap];
    
    // the point where the touch should change the movement direction
    _changeDirectionCriticalPoint = self.frame.size.height/6;
    
    // using Core Data with sqlite
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    NSError *error;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityAnswer = [NSEntityDescription
                                   entityForName:@"Answer" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityAnswer];
    self.allAnswers = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSFetchRequest *fetchRequestNew = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityQuestion = [NSEntityDescription
                                         entityForName:@"Question" inManagedObjectContext:managedObjectContext];
    [fetchRequestNew setEntity:entityQuestion];
    self.allQuestions = [managedObjectContext executeFetchRequest:fetchRequestNew error:&error];
    
    NSFetchRequest *fetchRequestPlayer = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityPlayers = [NSEntityDescription
                                         entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    [fetchRequestPlayer setEntity:entityPlayers];
    self.players = [managedObjectContext executeFetchRequest:fetchRequestPlayer error:&error];
    

//    // MARK: all this below is just to sort the scores and use them for the scoreboard at the finish page.. move it later when page is ready
//    Player *current = self.players[1];
//
//    NSArray *currentScores = [current valueForKey:@"scores"];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey: @"scoreValue" ascending:NO];
//    NSArray *sortedArray = [currentScores sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    NSPredicate *pred = [NSPredicate predicateWithFormat: @"scoreValue > 0"];
//    NSArray *filteredAndSortedArray = [sortedArray filteredArrayUsingPredicate: pred];
//    
//    int i = 1;
//    for (Score *sc in filteredAndSortedArray) {
//        NSLog(@"Score#%i + %@", i, sc.scoreValue);
//        i++;
//    }
//    
}

-(void) willMoveFromView:(SKView *)view {
    [self.view removeGestureRecognizer: gestureRecognizerSwipeDown];
    [self.view removeGestureRecognizer: gestureRecognizerSwipeUp];
    [self.view removeGestureRecognizer:gestureRecognizerDoubleTap];
}

-(void) swipeHandlerDown:(UISwipeGestureRecognizer *)recognizer {
    [hero makeHeroSmaller];
    self.isHeroSmaller = NO;
    
}

-(void) swipeHandlerUp:(UISwipeGestureRecognizer *)recognizer {
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
 
    NSLog(@"CONTACT BODY-A : %@", contact.bodyA.node.name);
    NSLog(@"CONTACT BODY-B : %@", contact.bodyB.node.name);
    
    // to prevent hero from jumping non-stop
    if ([contact.bodyA.node.name isEqualToString: @"back"] | [contact.bodyB.node.name isEqualToString: @"back"]
         | [contact.bodyA.node.name isEqualToString: @"hellGround"] | [contact.bodyB.node.name isEqualToString: @"hellGround"]) {
        [hero land];
    } else if ([contact.bodyA.node.name isEqualToString:@"snakeObstacle"]) {
        //[hero stop];
        self.paused = YES;
        contact.bodyA.node.name = @"snakeForCancelation";
        int rand = arc4random_uniform(10);
        [self generateQuiz:rand];

    } else if ([contact.bodyA.node.name isEqualToString:@"Teleport"]) {

        [hero removeFromParent];
        hero = [NIHero hero:@"greenman"];
        hero.alpha = 0.0;
        [self animateWithAlpha:hero];
        [hero start];
        hero.position = CGPointMake(contact.bodyA.node.position.x, contact.bodyA.node.position.y + 300);
        [world addChild:hero];
    }
    else {
        if (_heroLifes > _initialHeroFails) {
            _initialHeroFails++;
            [self runAction:[SKAction playSoundFileNamed:@"onHurt.wav" waitForCompletion:NO]];
            NSString *lifeImageString = [NSString stringWithFormat:@"Life-%i", _initialHeroFails];
            NIScoreMenuImage *lifeBurned = (NIScoreMenuImage *) [self childNodeWithName:lifeImageString];
            [lifeBurned removeFromParent];
            
            SKLabelNode *fireBurnMessage = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
            fireBurnMessage.position = CGPointMake(hero.position.x + hero.frame.size.width/3,
                                                   hero.position.y + hero.frame.size.height/2);
            fireBurnMessage.text = @"Ouch! It hurts!";
            fireBurnMessage.fontSize = 14;
            fireBurnMessage.fontColor = [UIColor redColor];
            fireBurnMessage.name = @"fireBurnMessage";
            [world addChild:fireBurnMessage];
            [self animateWithScale:fireBurnMessage];
            
            // this can reset hero ot its inital level position after each fail - too user unfriendly!?
            //        [hero removeFromParent];
            //        hero = [NIHero hero];
            //        [hero start];
            //        [world addChild:hero];
        }
    }
    

    if (_initialHeroFails >= _heroLifes) {
        [self runAction:[SKAction playSoundFileNamed:@"onGameOver.wav" waitForCompletion:NO]];
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
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    world = [SKNode node];
    [self addChild:world];
    
    generator = [NIWorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    
    hero = [NIHero hero:userChoiceHero];
    [world addChild:hero];
    
    gameData = [NIGameData initData];
    [gameData load];
    
    bestLabel = [NIPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    bestLabel.position = CGPointMake(-160, 85);
    bestLabel.name = @"bestScoreLabel";
    bestLabel.text = @"Best ";
    bestLabel.fontSize = 10;
    bestLabel.fontColor = [UIColor orangeColor];
    [self addChild:bestLabel];
    
    bestLabelValue = [NIPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    bestLabelValue.position = CGPointMake(-100, 85);
    bestLabelValue.name = @"bestScoreLabelValue";
    bestLabelValue.fontColor =[UIColor orangeColor];
    bestLabelValue.fontSize = 10;
    [bestLabelValue updatePoints:gameData.bestScore];

    [self addChild:bestLabelValue];
    
    scoreLabel = [NIPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    scoreLabel.position = CGPointMake(-155, 65);
    scoreLabel.name = @"scoreLabel";
    scoreLabel.text = @"Score ";
    scoreLabel.fontSize = 14;
    [self addChild:scoreLabel];
    
    scoreLabelValue = [NIPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    scoreLabelValue.position = CGPointMake(-100, 65);
    scoreLabelValue.name = @"scoreLabelValue";
    [self addChild:scoreLabelValue];
    
    pointsLabel = [NIPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    pointsLabel.position = CGPointMake(140, 80);
    pointsLabel.name = @"pointsLabel";
    [self addChild:pointsLabel];
    
    pointsImage = [NIScoreMenuImage scoreMenuImageWithNamedImage:@"7_gf_set_3"];
    pointsImage.position = CGPointMake(170, 90);
    pointsImage.xScale = 0.2;
    pointsImage.yScale = 0.2;
    [self addChild:pointsImage];
    
    blueRunesLabel = [NIPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    blueRunesLabel.position = CGPointMake(140, 60);
    blueRunesLabel.name = @"blueRuneLabel";
    [self addChild:blueRunesLabel];
    
    blueRunesImage = [NIScoreMenuImage scoreMenuImageWithNamedImage:@"7_gf_set_5"];
    blueRunesImage.position = CGPointMake(170, 70);
    blueRunesImage.xScale = 0.12;
    blueRunesImage.yScale = 0.12;
    [self addChild:blueRunesImage];
    
    firePointsLabel = [NIPointsLabel pointsLabelWithFontNamed:GAME_FONT];
    firePointsLabel.position = CGPointMake(140, 40);
    firePointsLabel.name = @"firePointsLabel";
    [self addChild:firePointsLabel];
    
    fireImage = [NIScoreMenuImage scoreMenuImageWithNamedImage:@"Fire-1"];
    fireImage.position = CGPointMake(170, 50);
    fireImage.xScale = 0.3;
    fireImage.yScale = 0.3;
    [self addChild:fireImage];
    
    // MARK: OK now add a special RUNE to add extra-life in the generator
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
    // [self runAction:[SKAction playSoundFileNamed:@"Lost-Jungle_Looping.mp3" waitForCompletion:NO]];
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
    
    [self setBestScore];
    [self saveNewScoreForPlayer];
    
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
    
    // - positionInTheScne.y - self.frame.size.width/10
    // (delete it to remove screen dynamic movement by y but will stay only at floor level)
}

-(void) handlePoints {
    
    [world enumerateChildNodesWithName:@"fireObstacle" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if (node.position.x < hero.position.x) {
            
            firePointsLabel = (NIPointsLabel *)[self childNodeWithName:@"firePointsLabel"];
            [firePointsLabel increment];
            
            scoreLabelValue = (NIPointsLabel *)[self childNodeWithName:@"scoreLabelValue"];
            [scoreLabelValue incrementWith:15];
        }
    }];
    
    [world enumerateChildNodesWithName:@"pointsBonusRune" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if ( (node.position.x < hero.position.x) &
            (node.position.y >= hero.position.y - 50 & node.position.y <= hero.position.y + 50) )  {
            
            [self runAction:[SKAction playSoundFileNamed:@"onPickCoin.wav" waitForCompletion:NO]];
            
            pointsLabel = (NIPointsLabel *)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
            
            scoreLabelValue = (NIPointsLabel *)[self childNodeWithName:@"scoreLabelValue"];
            [scoreLabelValue incrementWith:20];
            
            SKLabelNode *pointsCollectedMessage = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
            pointsCollectedMessage.position = CGPointMake(node.position.x + hero.frame.size.width/3,
                                                          node.position.y + hero.frame.size.height/2);
            pointsCollectedMessage.text = @"+20 Points!";
            pointsCollectedMessage.fontSize = 14;
            pointsCollectedMessage.zPosition = 3;
            pointsCollectedMessage.fontColor = [UIColor greenColor];
            pointsCollectedMessage.name = @"pointsCollectedMessage";
            [world addChild:pointsCollectedMessage];
            [self animateWithScale:pointsCollectedMessage];

        }
    }];

    
    [world enumerateChildNodesWithName:@"blueBonusRune" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if ( (node.position.x <= hero.position.x) &
            (node.position.y >= hero.position.y - 30 & node.position.y <= hero.position.y + 30) )  {

            [self runAction:[SKAction playSoundFileNamed:@"onPickCoin.wav" waitForCompletion:NO]];
            
            blueRunesLabel = (NIPointsLabel *)[self childNodeWithName:@"blueRuneLabel"];
            [blueRunesLabel increment];
            
            scoreLabelValue = (NIPointsLabel *)[self childNodeWithName:@"scoreLabelValue"];
            [scoreLabelValue incrementWith:70];
            
            SKLabelNode *pointsCollectedMessage = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
            pointsCollectedMessage.position = CGPointMake(node.position.x + hero.frame.size.width/3,
                                                          node.position.y + hero.frame.size.height/2);
            pointsCollectedMessage.text = @"+70 Points!";
            pointsCollectedMessage.fontSize = 14;
            pointsCollectedMessage.zPosition = 3;
            pointsCollectedMessage.fontColor = [UIColor greenColor];
            pointsCollectedMessage.name = @"pointsCollectedMessage";
            [world addChild:pointsCollectedMessage];
            [self animateWithScale:pointsCollectedMessage];
            
        }
    }];
    
    [world enumerateChildNodesWithName:@"redBonusRune" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if ( (node.position.x < hero.position.x) &
            (node.position.y >= hero.position.y - 20 & node.position.y <= hero.position.y + 20) )  {
            
            [self runAction:[SKAction playSoundFileNamed:@"onNewLife.wav" waitForCompletion:NO]];
            
            scoreLabelValue = (NIPointsLabel *)[self childNodeWithName:@"scoreLabelValue"];
            [scoreLabelValue incrementWith:1000];
            
            _heroLifes++;
            lifesRemainingImage = [NIScoreMenuImage scoreMenuImageWithNamedImage:@"red-greenman-1-0"];
            lifesRemainingImage.position = CGPointMake(_heroLifes  * 20, 90);
            lifesRemainingImage.xScale = 0.2;
            lifesRemainingImage.yScale = 0.2;
            lifesRemainingImage.name = [NSString stringWithFormat:@"Life-%i", _heroLifes];
            [self addChild:lifesRemainingImage];
            
            
            SKLabelNode *pointsCollectedMessage = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
            pointsCollectedMessage.position = CGPointMake(node.position.x + hero.frame.size.width/3,
                                                          node.position.y + hero.frame.size.height/2);
            pointsCollectedMessage.text = @"+1000 Points!";
            pointsCollectedMessage.fontSize = 14;
            pointsCollectedMessage.zPosition = 3;
            pointsCollectedMessage.fontColor = [UIColor greenColor];
            pointsCollectedMessage.name = @"pointsCollectedMessage";
            [world addChild:pointsCollectedMessage];
            [self animateWithScale:pointsCollectedMessage];
            
        }
    }];
}

-(void) saveNewScoreForPlayer {
    NSError *error = nil;
    Player *current = nil;
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext]];
    
    current = [[managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:1];
    
    Score *newScoreToSave = [NSEntityDescription insertNewObjectForEntityForName:@"Score" inManagedObjectContext:managedObjectContext];
    [newScoreToSave setValue:[NSNumber numberWithInteger:scoreLabelValue.number] forKey:@"scoreValue"];
    [newScoreToSave setValue:current forKey:@"owner"];

    if (error) {
        NSLog(@"Error fetching context at (saveNewScoreForPlayer)");
    }
    
    if (!newScoreToSave) {
        NSLog(@"No score to save..");
    }
    
    error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error saving to context at (saveNewScoreForPlayer)");
    }
    
    // Scores are updated on game over in sqlite via Core Data
//    for(NSNumber *score in current.scores) {
//        NSLog(@"CORE scores for curent user : %@", [score valueForKey:@"scoreValue"]);
//    }
}

-(void) setBestScore {
    
    NSError *error = nil;
    Player *current = nil;


    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext]];
    
    current = [[managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:1];

    if (scoreLabelValue.number > bestLabelValue.number) {
        
        [bestLabelValue updatePoints:scoreLabelValue.number];
        
        gameData.bestScore = bestLabelValue.number;
        [gameData save];
    }
    
    
    if ([NSNumber numberWithInteger:bestLabelValue.number ] > current.bestScore) {
       
        NSError *error = nil;
        Player *current = nil;
        
        //Set up to get the thing you want to update
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext]];
        current = [[managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:1];
        if (error) {
            NSLog(@"Error fetching context at (save bestScore)");
        }
        
        if (!current) {
            NSLog(@"No player to save bestScore to..");
        }
        
        [current setValue:[NSNumber numberWithInteger:bestLabelValue.number] forKey:@"bestScore"];
        
        error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Error saving to context at (save bestScore)");
        }
    }

}

-(void) handleGeneration {
    
[world enumerateChildNodesWithName:@"fireObstacle" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
     if (node.position.x < hero.position.x) {
         node.name = @"fireObstacleCanceled";
     }
 }];
    
[world enumerateChildNodesWithName:@"pointsBonusRune" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
    if (node.position.x < hero.position.x) {
        node.name = @"pointsBonusRuneCanceled";
    }
 }];

[world enumerateChildNodesWithName:@"redBonusRune" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
    if (node.position.x <= hero.position.x) {
        node.name = @"redBonusRuneCanceled";
    }
}];
  
[world enumerateChildNodesWithName:@"blueBonusRune" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
    if (node.position.x <= hero.position.x) {
        node.name = @"blueBonusRuneCanceled";
    }
}];

[world enumerateChildNodesWithName:@"wrongMessage" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
    if (node.position.x < hero.position.x - 100) {
        node.name = @"wrongMessageCanceled";
    }
}];
    
}

-(void) handleCleanup {
    
    // This method removes all objects that are left behind our hero...
    // CAUTION: I will have to remove it if the hero will be reurning back in the scene...
    // for example if i made level to go upstaris i do not want to clean whats behind...
    
//    [world enumerateChildNodesWithName:@"back" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
//        if (node.position.x < hero.position.x - self.frame.size.height/2 + node.frame.size.width/2) {
//            [node removeFromParent];
//        }
//    }];
//    
//    [world enumerateChildNodesWithName:@"fireObstacleCanceled" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
//        if (node.position.x < hero.position.x - self.frame.size.height/2 + node.frame.size.width/2) {
//            [node removeFromParent];
//        }
//    }];
//
    [world enumerateChildNodesWithName:@"pointsBonusRuneCanceled" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if ( (node.position.x <= hero.position.x) &
            (node.position.y >= hero.position.y - 50 & node.position.y <= hero.position.y + 50) ) {
            [node removeFromParent];
        }
    }];
    
    [world enumerateChildNodesWithName:@"blueBonusRuneCanceled" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if ( (node.position.x <= hero.position.x) &
            (node.position.y >= hero.position.y - 30 & node.position.y <= hero.position.y + 30) ) {
            [node removeFromParent];
        }
    }];
    
    [world enumerateChildNodesWithName:@"redBonusRuneCanceled" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if ( (node.position.x <= hero.position.x) &
            (node.position.y >= hero.position.y - 20 & node.position.y <= hero.position.y + 20) ) {
            [node removeFromParent];
        }
    }];

//
//    [world enumerateChildNodesWithName:@"background" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
//        if (node.position.x + node.frame.size.width < hero.position.x - self.frame.size.height/2 + node.frame.size.width/2) {
//            [node removeFromParent];
//        }
//    }];
//    
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
//
    [world enumerateChildNodesWithName:@"snakeForCancelation" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        [node removeFromParent];
    }];
    
    [world enumerateChildNodesWithName:@"wrongMessageCanceled" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        [node removeFromParent];
    }];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    CGFloat multiplierForDirection;
    
    if (!self.isStarted) {
        [self start];
    } else if (self.isGameOver) {
        [self clear];
        _initialHeroFails = 0;
    }
  
    if (location.x <= _changeDirectionCriticalPoint) {
        [hero walkLeft];
        //[hero startLeft];
        multiplierForDirection = -1;
    } else if (location.x > _changeDirectionCriticalPoint) {
        [hero walkRight];
        //[hero startRight];
        multiplierForDirection = 1;
    }
    
    hero.xScale = fabs(hero.xScale) * multiplierForDirection;

}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

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

-(void) animateWithAlpha:(SKNode *)node {
    
    SKAction *appear = [SKAction fadeAlphaTo:1.5 duration:1];
    SKAction *normalize = [SKAction fadeAlphaTo:1.0 duration:1];
    SKAction *scale = [SKAction sequence:@[appear, normalize]];
    
    [node runAction:scale];
}

-(void) generateQuiz: (int) index {
    
    Question *randomQuestion = self.allQuestions[index];
    NSString *currentQuestion = [randomQuestion valueForKey:@"text"];
    // NSLog(@"%@", currentQuestion);
    NSSet<Answer *> *questionAnswers = [randomQuestion valueForKey:@"questionAnswers"];
    NSMutableArray *currentAnswers = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    NSMutableArray *currentTrueValues = [NSMutableArray arrayWithCapacity:4];
    // NSLog(@"%i", currentAnswers.count);
    int i = 0;
    for (Answer *an in questionAnswers) {
        currentAnswers[i] = [an valueForKey:@"text"];
        currentTrueValues[i] = [an valueForKey:@"isTrue"];
        i++;
    
    }
    
    quizView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3.5,
                                                                self.view.frame.size.height/8,
                                                                self.view.frame.size.width/1.5,
                                                                self.view.frame.size.height/1.3)];
    quizView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:quizView];
    
    intro = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3.5,
                                                               self.view.frame.size.height/8,
                                                               self.view.frame.size.width/1.5,
                                                               self.view.frame.size.height/6)];
    intro.text = @" I am the Coder snake - You will have to answer my coder question or I will take one of those lifes of yours! Here is my riddle.. ";
    intro.backgroundColor = [UIColor whiteColor];
    intro.adjustsFontSizeToFitWidth = NO;
    intro.numberOfLines = 0;
    intro.textAlignment = NSTextAlignmentCenter;
    intro.font = [UIFont fontWithName:GAME_FONT size:14];
    intro.textColor = [UIColor brownColor];
    
    question = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3.5,
                                                                  self.view.frame.size.height/8 + intro.frame.size.height,
                                                                  self.view.frame.size.width/1.5,
                                                                  self.view.frame.size.height/10)];
    // question.text = gameData.questions[index];  // NSData qorking scenario... Update : Core Data enabled!
    question.text = currentQuestion; // Core Data
    question.backgroundColor = [UIColor redColor];
    question.adjustsFontSizeToFitWidth = NO;
    question.numberOfLines = 0;
    question.textAlignment = NSTextAlignmentCenter;
    question.font = [UIFont fontWithName:GAME_FONT size:14];
    question.textColor = [UIColor whiteColor];
    
    answerOne = [NIQuizButton initWithFrameAndFalseValue:CGRectMake(self.view.frame.size.width/3.5 + question.frame.size.width/6,
                                                                     self.view.frame.size.height/8 + intro.frame.size.height + question.frame.size.height*1.5,
                                                                     self.view.frame.size.width/2,
                                                                     self.view.frame.size.height/12)];
    [answerOne setTitle:currentAnswers[0] forState:UIControlStateNormal];
    [answerOne setValue:currentTrueValues[0]  forKey:@"isTrue"];
    [answerOne addTarget:self action:@selector(answerClicked:)
        forControlEvents:UIControlEventTouchUpInside];

    
    answerTwo = [NIQuizButton initWithFrameAndFalseValue:CGRectMake(self.view.frame.size.width/3.5 + question.frame.size.width/6,
                                                                     self.view.frame.size.height/8 + intro.frame.size.height + question.frame.size.height*1.5 + answerOne.frame.size.height + 10,
                                                                     self.view.frame.size.width/2,
                                                                     self.view.frame.size.height/12)];
    // [answerTwo setTitle:gameData.answers[index+4] forState:UIControlStateNormal]; // NSData can be used here as well..going to CoreData
    [answerTwo setTitle:currentAnswers[1] forState:UIControlStateNormal];
    [answerTwo setValue:currentTrueValues[1]  forKey:@"isTrue"];
    [answerTwo addTarget:self action:@selector(answerClicked:)
        forControlEvents:UIControlEventTouchUpInside];

    
    
    answerThree = [NIQuizButton initWithFrameAndFalseValue:CGRectMake(self.view.frame.size.width/3.5
                                                                 + question.frame.size.width/6,
                                                                       self.view.frame.size.height/8 + intro.frame.size.height + question.frame.size.height*1.5 + answerOne.frame.size.height*2 + 20,
                                                                       self.view.frame.size.width/2,
                                                                       self.view.frame.size.height/12)];
    [answerThree setTitle:currentAnswers[2] forState:UIControlStateNormal];
    [answerThree setValue:currentTrueValues[2]  forKey:@"isTrue"];
    [answerThree addTarget:self action:@selector(answerClicked:)
        forControlEvents:UIControlEventTouchUpInside];



    answerFour = [NIQuizButton initWithFrameAndFalseValue:CGRectMake(self.view.frame.size.width/3.5 + question.frame.size.width/6,
                                                                     self.view.frame.size.height/8 + intro.frame.size.height + question.frame.size.height*1.5 + answerOne.frame.size.height*3 + 30,
                                                                     self.view.frame.size.width/2,
                                                                     self.view.frame.size.height/12)];
    [answerFour setTitle:currentAnswers[3] forState:UIControlStateNormal];
    [answerFour setValue:currentTrueValues[3]  forKey:@"isTrue"];
    [answerFour addTarget:self action:@selector(answerClicked:)
        forControlEvents:UIControlEventTouchUpInside];

    [self addQuizElements];
}

- (IBAction)answerClicked:(id)sender
{
    if ([[sender valueForKey:@"isTrue"]  isEqual: [NSNumber numberWithBool:YES]]) {
        
        self.paused = NO;
        [self removeQuizElements];
        [self runAction:[SKAction playSoundFileNamed:@"onRightAnswer.wav" waitForCompletion:NO]];
        SKLabelNode *rightAnswerMessage = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
        rightAnswerMessage.position = CGPointMake(hero.position.x + hero.frame.size.width/3,
                                                  hero.position.y + hero.frame.size.height/2);
        rightAnswerMessage.text = @"+100 Points!";
        rightAnswerMessage.fontSize = 14;
        rightAnswerMessage.fontColor = [UIColor greenColor];
        rightAnswerMessage.name = @"wrongMessage";
        [world addChild:rightAnswerMessage];
        [self animateWithScale:rightAnswerMessage];
        
        scoreLabelValue = (NIPointsLabel *)[self childNodeWithName:@"scoreLabelValue"];
        [scoreLabelValue incrementWith:100];

    }
    else {
        [world enumerateChildNodesWithName:@"snakeForCancelation" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
            [node removeFromParent];
        }];

        self.paused = NO;
        [self removeQuizElements];
        [self runAction:[SKAction playSoundFileNamed:@"onWrongAnswer.wav" waitForCompletion:NO]];
        _initialHeroFails++;
        NSString *lifeImageString = [NSString stringWithFormat:@"Life-%i", _initialHeroFails];
        NIScoreMenuImage *lifeBurned = (NIScoreMenuImage *) [self childNodeWithName:lifeImageString];
        [lifeBurned removeFromParent];
        
        SKLabelNode *wrongAnswerMessage = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
        wrongAnswerMessage.position = CGPointMake(hero.position.x + hero.frame.size.width/3,
                                                  hero.position.y + hero.frame.size.height/2);
        wrongAnswerMessage.text = @"-30 Points!";
        wrongAnswerMessage.fontSize = 14;
        wrongAnswerMessage.fontColor = [UIColor redColor];
        wrongAnswerMessage.name = @"wrongMessage";
        [world addChild:wrongAnswerMessage];
        [self animateWithScale:wrongAnswerMessage];
        
        scoreLabelValue =(NIPointsLabel *)[self childNodeWithName:@"scoreLabelValue"];
        [scoreLabelValue incrementWith:-30];
    }
}

- (void) addQuizElements {
    [self.view addSubview:intro];
    [self.view addSubview:question];
    [self.view addSubview:answerOne];
    [self.view addSubview:answerTwo];
    [self.view addSubview:answerThree];
    [self.view addSubview:answerFour];
}

- (void) removeQuizElements {
    [quizView removeFromSuperview];
    [intro removeFromSuperview];
    [question removeFromSuperview];
    [answerOne removeFromSuperview];
    [answerTwo removeFromSuperview];
    [answerThree removeFromSuperview];
    [answerFour removeFromSuperview];
}

-(void) addLoopingMusicToBackground: (NSString*)path {
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    resourcePath = [resourcePath stringByAppendingString:path];
    NSLog(@"Path to play: %@", resourcePath);
    NSError* err;
    
    //Initialize our player pointing to the path to our resource
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:
              [NSURL fileURLWithPath:resourcePath] error:&err];
    
    if( err ){
        //bail!
        NSLog(@"Failed with reason: %@", [err localizedDescription]);
    }
    else{
        //set our delegate and begin playback
        audioPlayer.delegate = self;
        [audioPlayer play];
        audioPlayer.numberOfLoops = -1;
        audioPlayer.currentTime = 0;
        audioPlayer.volume = 0.3;
    }
}


@end
