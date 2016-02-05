//
//  Score+CoreDataProperties.h
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 2/5/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Score.h"

NS_ASSUME_NONNULL_BEGIN

@interface Score (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *scoreValue;
@property (nullable, nonatomic, retain) Player *owner;

@end

NS_ASSUME_NONNULL_END
