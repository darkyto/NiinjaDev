//
//  NIPointsImage.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/30/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "NIPointsImage.h"

@implementation NIPointsImage
+(id)pointsImageWithNamedImage:(NSString*) imageName {
    NIPointsImage *pointsImage = [NIPointsImage spriteNodeWithImageNamed:imageName];
    pointsImage.physicsBody.dynamic = NO;
    pointsImage.xScale = 0.2;
    pointsImage.yScale = 0.2;
    pointsImage.name = @"pointsImage";
    return  pointsImage;
}

@end
