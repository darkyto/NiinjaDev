//
//  GameViewController.h
//  NiinjaDev
//

//  Copyright (c) 2016 iNick Iliev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "CoreData/CoreData.h"

@interface GameViewController : UIViewController

@property (strong, nonatomic) NSString *userChoiceHero;

// Core Data properties
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSArray *players;


@end