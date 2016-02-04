//
//  NIGameData.h
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 2/4/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIGameData : NSObject

@property int bestScore;

+ (id)initData;
- (void)save;
- (void)load;

@end
