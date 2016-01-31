//
//  NIPointsImage.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/30/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "NIScoreMenuImage.h"

@implementation NIScoreMenuImage
+(id)scoreMenuImageWithNamedImage:(NSString*) imageName {
    NIScoreMenuImage *pointsImage = [NIScoreMenuImage spriteNodeWithImageNamed:imageName];
    pointsImage.physicsBody.dynamic = NO;
    pointsImage.name = @"pointsImage";
    return  pointsImage;
}

@end
