//
//  Player+CoreDataProperties.h
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 2/5/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Player.h"

NS_ASSUME_NONNULL_BEGIN

@interface Player (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *bestScore;
@property (nullable, nonatomic, retain) NSOrderedSet<Score *> *scores;

@end

@interface Player (CoreDataGeneratedAccessors)

- (void)insertObject:(Score *)value inScoresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromScoresAtIndex:(NSUInteger)idx;
- (void)insertScores:(NSArray<Score *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeScoresAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInScoresAtIndex:(NSUInteger)idx withObject:(Score *)value;
- (void)replaceScoresAtIndexes:(NSIndexSet *)indexes withScores:(NSArray<Score *> *)values;
- (void)addScoresObject:(Score *)value;
- (void)removeScoresObject:(Score *)value;
- (void)addScores:(NSOrderedSet<Score *> *)values;
- (void)removeScores:(NSOrderedSet<Score *> *)values;

@end

NS_ASSUME_NONNULL_END
