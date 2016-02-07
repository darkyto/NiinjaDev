//
//  AppDelegate.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/29/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <SpriteKit/SpriteKit.h>

#import "GameScene.h"

#import "Player.h"
#import "Score.h"
#import "Question.h"
#import "Answer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    SEED PLayer and scores
    
//    NSManagedObjectContext *context = [self managedObjectContext];
//    Player *playa = [NSEntityDescription
//                            insertNewObjectForEntityForName:@"Player"
//                            inManagedObjectContext:context];
//    [playa setValue:@"Amon Ra" forKey:@"name"];
//    [playa setValue:[NSNumber numberWithInteger:0] forKey:@"bestScore"];
//    
//    Score *sampleScoreOne = [NSEntityDescription
//                     insertNewObjectForEntityForName:@"Score"
//                     inManagedObjectContext:context];
//    [sampleScoreOne setValue:[NSNumber numberWithInteger:70] forKey:@"scoreValue"];
//    [sampleScoreOne setValue:playa forKey:@"owner"];
//    
//    Score *sampleScoreTwo = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"Score"
//                              inManagedObjectContext:context];
//    [sampleScoreTwo setValue:[NSNumber numberWithInteger:405] forKey:@"scoreValue"];
//    [sampleScoreTwo setValue:playa forKey:@"owner"];
//    
//    Score *sampleScoreThree = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"Score"
//                              inManagedObjectContext:context];
//    [sampleScoreThree setValue:[NSNumber numberWithInteger:160] forKey:@"scoreValue"];
//    [sampleScoreThree setValue:playa forKey:@"owner"];
//    
//    Score *sampleScoreFour = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"Score"
//                              inManagedObjectContext:context];
//    [sampleScoreFour setValue:[NSNumber numberWithInteger:225] forKey:@"scoreValue"];
//    [sampleScoreFour setValue:playa forKey:@"owner"];


    
//    SEED Question and naswers (the snake quiz)
    
//    NSManagedObjectContext *context = [self managedObjectContext];
//    Question *question = [NSEntityDescription
//                          insertNewObjectForEntityForName:@"Question"
//                          inManagedObjectContext:context];
//    [question setValue:@" 11.) Arabic numerals originated in which country?" forKey:@"text"];
//    
//    Answer *answer1 = [NSEntityDescription
//                       insertNewObjectForEntityForName:@"Answer"
//                       inManagedObjectContext:context];
//    [answer1 setValue:@"Persia" forKey:@"text"];
//    [answer1 setValue:[NSNumber numberWithBool:NO]forKey:@"isTrue"];
//    [answer1 setValue:question forKey:@"relationship"];
//    Answer *answer2 = [NSEntityDescription
//                       insertNewObjectForEntityForName:@"Answer"
//                       inManagedObjectContext:context];
//    [answer2 setValue:@"India" forKey:@"text"];
//    [answer2 setValue:[NSNumber numberWithBool:YES]forKey:@"isTrue"];
//    [answer2 setValue:question forKey:@"relationship"];
//    Answer *answer3 = [NSEntityDescription
//                       insertNewObjectForEntityForName:@"Answer"
//                       inManagedObjectContext:context];
//    [answer3 setValue:@"Egypt" forKey:@"text"];
//    [answer3 setValue:[NSNumber numberWithBool:NO]forKey:@"isTrue"];
//    [answer3 setValue:question forKey:@"relationship"];
//    Answer *answer4 = [NSEntityDescription
//                       insertNewObjectForEntityForName:@"Answer"
//                       inManagedObjectContext:context];
//    [answer4 setValue:@"Syria" forKey:@"text"];
//    [answer4 setValue:[NSNumber numberWithBool:NO]forKey:@"isTrue"];
//    [answer4 setValue:question forKey:@"relationship"];
//
  
    
//    TEST the SEED
    
//    NSError *error;
//    if (![context save:&error]) {
//        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//    }
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription
//                                   entityForName:@"Player" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
//    
//    NSLog(@"Players count from AppDelegate :  %i", (int)fetchedObjects.count);
//    for (NSManagedObject *info in fetchedObjects) {
//        NSLog(@"Name: %@", [info valueForKey:@"name"]);
//        NSLog(@"Best Score: %@", [info valueForKey:@"bestScore"]);
//    }
//    
    GameScene *scene = [[GameScene alloc] init];
    scene.managedObjectContext = self.managedObjectContext;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // to prevent from crashing when the app goes into background (phone call...)
    SKView *view = (SKView *) self.window.rootViewController;
    view.paused = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    SKView *view = (SKView *) self.window.rootViewController;
    view.paused = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.iliev.nikana.CoreNew" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Scoreboard" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TestGameDataDB.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
