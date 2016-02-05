//
//  Question+CoreDataProperties.h
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 2/5/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Question.h"

NS_ASSUME_NONNULL_BEGIN

@interface Question (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSSet<Answer *> *questionAnswers;

@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addQuestionAnswersObject:(Answer *)value;
- (void)removeQuestionAnswersObject:(Answer *)value;
- (void)addQuestionAnswers:(NSSet<Answer *> *)values;
- (void)removeQuestionAnswers:(NSSet<Answer *> *)values;

@end

NS_ASSUME_NONNULL_END
