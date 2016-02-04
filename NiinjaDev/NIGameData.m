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
    [data writeToFile:self.filepath atomically:YES];
}

- (void)load {
    NSData *data = [NSData dataWithContentsOfFile:self.filepath];
    NSNumber *bestScoreObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.bestScore = bestScoreObj.intValue;
}

@end
