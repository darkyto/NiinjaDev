//
//  NIGameData.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 2/4/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "NIGameData.h"

@interface NIGameData ()

@property NSString *filepath;

@end

@implementation NIGameData

+ (id)initData {
    NIGameData *data = [[NIGameData alloc] init];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = @"scores.data";
    data.filepath = [path stringByAppendingString:filename];
    return data;
}

- (void)save {
    NSNumber *bestScore = [NSNumber numberWithInt:self.bestScore];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bestScore];

    

//    NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:questions];
//    
//
//    NSData *data3 = [NSKeyedArchiver archivedDataWithRootObject:answers];
//    NSMutableData *completeData = [data mutableCopy];
//    
//    [completeData appendData:data2];
//    [completeData appendData:data3];
    [data writeToFile:self.filepath atomically:YES];

}

- (void)load {
    NSData *data = [NSData dataWithContentsOfFile:self.filepath];
    NSNumber *dataObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.bestScore = dataObj.intValue;
    
    NSMutableArray *questions = [NSMutableArray arrayWithObjects:
                                 @"int a = 5; var int = 2; var c = a/b; c=?",
                                 @"The copy constructor is executed on",
                                 @"Question 2",
                                 @"Question 3",
                                 @"Question 4",
                                 @"Question 5",
                                 @"Question 6",
                                 @"Question 7",
                                 @"Question 8", nil];
    NSMutableArray *answers = [NSMutableArray arrayWithObjects:
                               @"Easy-deasy 2.5", @"I will say 3", @"What about 2", @"You gotta be joking..",
                               @"Asigned one object to another object at its creation", @"When objects are sent to function using callvby value", @"When the function returns an onject", @"All of the above",
                               @"Answer 5", @"Answer 6", @"Answer 7", @"Answer 8",
                               @"Answer 15", @"Answer 16", @"Answer 17", @"Answer 18",
                               @"Answer 25", @"Answer 26", @"Answer 27", @"Answer 28",
                               @"Answer 35", @"Answer 36", @"Answer 37", @"Answer 38",
                               @"Answer 45", @"Answer 46", @"Answer 47", @"Answer 48",
                               @"Answer 55", @"Answer 56", @"Answer 57", @"Answer 58",
                               @"Answer 65", @"Answer 66", @"Answer 67", @"Answer 68",
                               @"Answer 75", @"Answer 76", @"Answer 77", @"Answer 78", nil];
    
    self.questions = questions;
    self.answers = answers;
}

@end
