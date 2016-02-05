//
//  Answer+CoreDataProperties.h
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 2/5/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Answer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Answer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSNumber *isTrue;
@property (nullable, nonatomic, retain) Question *relationship;

@end

NS_ASSUME_NONNULL_END
