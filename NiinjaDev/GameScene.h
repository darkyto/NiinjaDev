
//
//  GameScene.h
//  NiinjaDev
//
//  Copyright (c) 2016 iNick Iliev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreData/CoreData.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSArray *players;

@property (nonatomic, strong) NSArray *allAnswers;

@property (nonatomic, strong) NSArray *allQuestions;

-(instancetype)initWithSize:(CGSize)size andUserChoiceHero:(NSString *)userChoiceHero;

+(id)initWithSize:(CGSize)size andUserChoiceHero:(NSString *)userChoiceHero;

@end
